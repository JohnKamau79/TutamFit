const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const {defineString} = require("firebase-functions/params");

admin.initializeApp();
const db = admin.firestore();

// --- Mpesa params ---
const MPESA_CONSUMER_KEY = defineString("MPESA_CONSUMER_KEY");
const MPESA_CONSUMER_SECRET = defineString("MPESA_CONSUMER_SECRET");
const MPESA_SHORTCODE = defineString("MPESA_SHORTCODE");
const MPESA_PASSKEY = defineString("MPESA_PASSKEY");
const MPESA_CALLBACK_URL = defineString("MPESA_CALLBACK_URL");

// --- Get access token ---
async function getAccessToken() {
  const auth = Buffer.from(
      `${MPESA_CONSUMER_KEY.value()}:${MPESA_CONSUMER_SECRET.value()}`,
  ).toString("base64");

  const res = await axios.get(
      "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials",
      {headers: {Authorization: `Basic ${auth}`}},
  );

  return res.data.access_token;
}

// --- STK push function ---
async function stkPush(phone, amount, orderId) {
  const token = await getAccessToken();

  const timestamp = new Date()
      .toISOString()
      .replace(/[-:TZ.]/g, "")
      .slice(0, 14);

  const password = Buffer.from(
      MPESA_SHORTCODE.value() + MPESA_PASSKEY.value() + timestamp,
  ).toString("base64");

  const payload = {
    BusinessShortCode: MPESA_SHORTCODE.value(),
    Password: password,
    Timestamp: timestamp,
    TransactionType: "CustomerPayBillOnline",
    Amount: amount,
    PartyA: phone,
    PartyB: MPESA_SHORTCODE.value(),
    PhoneNumber: phone,
    CallBackURL: MPESA_CALLBACK_URL.value(),
    AccountReference: orderId,
    TransactionDesc: "TutamFit Order Payment",
  };

  return axios.post(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      payload,
      {headers: {Authorization: `Bearer ${token}`}},
  );
}

// --- Checkout ---
exports.checkout = functions.https.onCall(async (data, context) => {
  const userId = context.auth && context.auth.uid;
  const phone = data.phone;

  if (!userId) {
    throw new functions.https.HttpsError(
        "User not logged in",
    );
  }
  if (!phone) {
    throw new functions.https.HttpsError(

        "Phone number required",
    );
  }

  let orderId;
  let total = 0;

  await db.runTransaction(async (tx) => {
    const cartRef = db.collection("cart").doc(userId);
    const cartSnap = await tx.get(cartRef);

    if (!cartSnap.exists) {
      throw new functions.https.HttpsError("Cart is empty");
    }

    const items = cartSnap.data().items;
    const orderItems = [];

    for (const item of items) {
      const productRef = db.collection("product").doc(item.productId);
      const productSnap = await tx.get(productRef);

      const stock = productSnap.data().stock;
      if (stock < item.quantity) {
        throw new functions.https.HttpsError("Insufficient stock");
      }

      tx.update(productRef, {stock: stock - item.quantity});

      const price = productSnap.data().price;
      total += price * item.quantity;

      orderItems.push({
        productId: item.productId,
        price,
        quantity: item.quantity,
      });
    }

    const orderRef = db.collection("order").doc();
    orderId = orderRef.id;

    tx.set(orderRef, {
      userId,
      products: orderItems,
      totalPrice: total,
      status: "awaiting_payment",
      paymentMethod: "mpesa",
      currency: "KES",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    tx.delete(cartRef);
  });

  // --- Make STK push and save CheckoutRequestID ---
  const stkRes = await stkPush(phone, total, orderId);

  await db.collection("order").doc(orderId).update({
    checkoutRequestID: stkRes.data.CheckoutRequestID,
  });

  return {orderId};
});

// --- Mpesa callback ---
exports.mpesaCallback = functions.https.onRequest(async (req, res) => {
  try {
    const data = req.body.Body.stkCallback;
    const checkoutRequestID = data.CheckoutRequestID || data.checkoutRequestID;
    const resultCode = data.ResultCode;

    const orders = await db
        .collection("order")
        .where("checkoutRequestID", "==", checkoutRequestID)
        .get();

    if (orders.empty) return res.status(400).send("Order not found");

    const orderRef = orders.docs[0].ref;

    if (resultCode === 0) {
      await orderRef.update({
        status: "paid",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    } else {
      await orderRef.update({
        status: "failed",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    res.sendStatus(200);
  } catch (error) {
    res.status(500).send(error.toString());
  }
});

// --- Cancel order ---
exports.cancelOrder = functions.https.onCall(async (data, context) => {
  const userId = context.auth && context.auth.uid;
  const orderId = data.orderId;

  if (!userId) throw new functions.https.HttpsError("unauthenticated");

  const orderRef = db.collection("order").doc(orderId);
  const orderSnap = await orderRef.get();

  if (!orderSnap.exists) throw new functions.https.HttpsError("not-found");

  const order = orderSnap.data();

  if (!["awaiting_payment", "processing"].includes(order.status)) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "Cannot cancel",
    );
  }

  await db.runTransaction(async (tx) => {
    for (const item of order.products) {
      const productRef = db.collection("product").doc(item.productId);
      const productSnap = await tx.get(productRef);
      tx.update(productRef, {
        stock: productSnap.data().stock + item.quantity,
      });
    }

    tx.update(orderRef, {
      status: "cancelled",
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });
  });

  return {success: true};
});

// --- Admin update order ---
exports.adminUpdateOrder = functions.https.onCall(async (data, context) => {
  const uid = context.auth && context.auth.uid;
  const {orderId, status} = data;

  const userSnap = await db.collection("users").doc(uid).get();
  if (!userSnap.exists || userSnap.data().role !== "admin") {
    throw new functions.https.HttpsError("permission-denied");
  }

  await db.collection("order").doc(orderId).update({
    status,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  return {success: true};
});

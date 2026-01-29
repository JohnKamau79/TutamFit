# tutam_fit

# GIT COMMANDS
- git remote -v
- git remote remove origin

- echo "# TutamFit" >> README.md
- git init
- git add README.md
- git commit -m "first commit"
- git branch -M main
- git remote add origin https://github.com/JohnKamau79/TutamFit.git
- git push -u origin main

# 19/1/2026
- Set up of flutter project,install dependencies,create firebase project and connect app

# 20/1/2026
- Design firebase schema
- Design models and providers

# 21/1/2026
- Design repositories

# 23/1/2026
- Design providers connected to repositories
- Created firebase database ( europe-west1 (Belgium) - Closer thus low latency, meaning faster app response, lower billing costs )
- Enforce rules for admin and user in firebase database
- Set up android
    # COMMAND
    - cd android
    - gradlew signingReport (Ensure Java 17 installed and path set in pc environmental variables )
- Pasted SHA-1 and SHA-256 into Firebase -> project-settings -> android app for security
- Downloaded **Google-service.json file after saving SHA, and replaced in android -> app**

# 24/1/2026
- Added google-sign-in **version 6.2.0**
- Added email&password signup/signin + userRepository integration

# 28/1/2026
- Order logic improved
- Mpesa payment logic for initiated, paid, failed

# 29/1/2026
- Attempt to use **Firebase (Node.js Cloud Functions)** for mpesa payment, checkout, stock and security
    # COMMANDS
    - npm install -g firebase-tools
    - firebase login
    - firebase init (set-up)
- Set mpesa secrets
    # COMMANDS
    - firebase experiments:enable legacyRuntimeConfigCommands
    - 

-Built **SplashScreen**,  **HomeScreen** and **GoRouter logic**
    # COMMANDS
    - gradlew build -Xlint:deprecation (To check list of deprecated code syntax)
    

   


# COMMANDS

- npm install -g firebase-tools
- firebase --version
- firebase login
- dart pub global activate flutterfire_cli
- flutterfire --version
- Create New Project [ Firebase ]
- flutter configure [ To create firebase_options.dart ]
- flutter clean
- flutter pub get
- flutter run

# part 'user_model.g.dart';
- Uses **json_annotation** package

# COMMANDS
- flutter pub run build_runner build
- flutter pub run build_runner build --delete-conflicting-outputs



# COMMANDS
- flutter clean

# Quiz
- Stream<User?> authStateChanges() => _auth.authStateChanges();
- auth_repository and provider
- signInWithEmailAndPassword, Normal sign in, google sign in connection
- final user = cred.user!;









MPESA_CONSUMER_KEY= kLFRYs2fK6qgstpOs3LOCzPTr6H5SDpjJww5reNIRyVGJSox
MPESA_CONSUMER_SECRET= perCKS9gwQsyc7wohxhGCfWLpXsafAFfCcGQSRmR0It65jfDy1bGA8hqrnnhXkKc
MPESA_SHORTCODE= 174379
MPESA_PASSKEY= bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919
MPESA_CALLBACK_URL=   https://d4cc2257cae5.ngrok-free.app/mpesa/callback
MPESA_ENV=sandbox




firebase functions:params:set MPESA_CONSUMER_KEY="kLFRYs2fK6qgstpOs3LOCzPTr6H5SDpjJww5reNIRyVGJSox"
firebase functions:params:set MPESA_CONSUMER_SECRET="perCKS9gwQsyc7wohxhGCfWLpXsafAFfCcGQSRmR0It65jfDy1bGA8hqrnnhXkKc"
firebase functions:params:set MPESA_SHORTCODE="174379"
firebase functions:params:set MPESA_PASSKEY="bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
firebase functions:params:set MPESA_CALLBACK_URL="https://d4cc2257cae5.ngrok-free.app/mpesa/callback"










const Booking = require('../models/Booking')
const Event = require('../models/Events')
const axios = require('axios')


const getAccessToken = async () => {
    const auth = Buffer.from(`${ process.env.MPESA_CONSUMER_KEY}:${ process.env.MPESA_CONSUMER_SECRET}`).toString('base64');
    const { data } = await axios.get(
        'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
        {headers: { Authorization: `Basic ${auth}`}}
    );
    return data.access_token;
};


const bookEvent = async (req, res) => {
    try{
        const {eventId, tickets, phoneNumber} = req.body;

        const event = await Event.findById(eventId)
        if(!event){
            return res.status(404).json({message: "Event not found"})
        }
        if(event.availableTickets < tickets){
            return res.status(400).json({message: "Not enough tickets available"})
        }

        const booking = await Booking.create({
            user: req.user.id,
            event: event.id,
            tickets,
            phoneNumber,
            paid: false,
            // paymentMethod: 'mpesa'
        })
        event.availableTickets -= tickets
        await event.save()

        
        const timestamp = new Date().toISOString().replace(/[-T:.Z]/g,'').slice(0, 14);
        const password = Buffer.from(`${process.env.MPESA_SHORTCODE}${process.env.MPESA_PASSKEY}${timestamp}`).toString('base64')
        
        const token = await getAccessToken();
        
        const payload = {
            BusinessShortCode: process.env.MPESA_SHORTCODE,
            Password: password,
            Timestamp: timestamp,
            TransactionType: 'CustomerPayBillOnline',
            Amount: tickets * event.price,
            PartyA: phoneNumber,
            PartyB: process.env.MPESA_SHORTCODE,
            PhoneNumber: phoneNumber,
            CallBackURL: process.env.CALLBACK_URL,
            AccountReference: `Ticketeezz`,
            TransactionDesc: 'Ticket Booking Payment'
        }
        
                const { data } = await axios.post(
                    'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest',
                    payload,
                    { headers: { Authorization: `Bearer ${token}`}}
                )
        
                res.status(201).json({message: 'Booking created and STK Push initiated', booking, stkPushResponse: data})
    }

    catch(error){
        res.status(500).json({message: 'Booking or payment initiation failed', error: error.message})
    }
}

const getBookings = async(req, res) => {
    try{
        let bookings;

        if(req.user.role === 'admin'){
            bookings = await Booking.find().populate('event').populate('user', "name email")
        }
        else if(req.user.role === 'organizer'){
            const events = await Event.find({ organizer:req.user.id}).select("_id")
            const eventIds = events.map((e) => e._id)
            bookings = await Booking.find( {event: { $in:eventIds}}).populate("event").populate("user", "name email")
        }
        else{
            bookings = await Booking.find( {user: req.user.id}).populate("event").populate("user", "name email")
        }
        res.json(bookings);
    }
    catch(err){
        console.error(err);
        res.status(500).json({ error: "Server error"})
    }
}

module.exports =  { bookEvent, getBookings }
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

- Built **SplashScreen**,  **HomeScreen** and **GoRouter logic**
    # COMMANDS
    - gradlew build -Xlint:deprecation (To check list of deprecated code syntax)
    
# 06/2/2026
- Auth screens set up and routing
   
# 07/2/2026
- Updated app name in android\app\src\main\AndroidManifest.xml [ android:label="TutamFit" ]
- Set up app icon
    # COMMANDS
    - flutter pub add --dev flutter_launcher_icons [ Created flutter_launcher_icons file in pubspec.yaml ]
    - flutter pub run flutter_launcher_icons:main
    - flutter clean
    - flutter pub get

- Set up flutter native splash
    # COMMANDS
    - flutter pub add --dev flutter_native_splash [ Created flutter_native_splash file in pubspec.yaml ]
    - dart run flutter_native_splash:create
    - flutter clean
    - flutter pub get

    # ALL COMMANDS
    - flutter pub get
    - flutter pub run flutter_launcher_icons:main
    - flutter pub run flutter_native_splash:create
    - rmdir /s /q build
    - flutter run




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









# PRIMARY COLORS
| Role                 | Color     | HEX     | Notes                            |
| -------------------- | --------- | ------- | -------------------------------- |
| Main Brand / Buttons | Fiery Red | #E53935 | Energy, action, motivates clicks |
| Background / Cards   | Dark Gray | #212121 | Strong, neutral, modern          |
| Header / Accents     | Deep Navy | #0D47A1 | Trustworthy, balances red        |

# ACCENT COLORS
| Role               | Color          | HEX     | Notes                    |
| ------------------ | -------------- | ------- | ------------------------ |
| Highlights / Icons | Vibrant Orange | #FB8C00 | Fun, active energy       |
| Success / Health   | Lime Green     | #C0CA33 | Health, vitality, subtle |
| Warnings / Alerts  | Yellow         | #FFEB3B | Eye-catching, sparingly  |

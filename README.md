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
  # COMMANDS
  - flutter pub run build_runner build
  - flutter pub run build_runner build --delete-conflicting-outputs ( scan all files with **@JsonSerializable()**, builds **.g.dart files**, enable use with **fromJson** & **toJson** )

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

- Built **SplashScreen**, **HomeScreen** and **GoRouter logic**
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

# 09/2/2026

- Updated splash screen UI
- Set up home screen layout with **GridView builder + GestureDetector**
- Set up tabs and **appShell** / main screen to navigate through the tabs
- Set up category screen UI **ListView builder + GestureDetector** and **GridView builder GestureDetector**

# 10/2/2026

- Set up message screen with **InkWell** layout
- Set up account screen with **ListStyle** layout
- Created files and routes for all remaining pages
- Set up free **Cloudinary** account and created new **unasigned** **upload preset** ( Won't be needing Cloudinary API keys )
- Added **image_picker, http and cloud_firestore** for **Cloudinary**

# 11/2/2026
- Updated categoryModel with categoryType as list
- Created and set up category form
- Added cloudinary upload and url return logic to category form using **setState**
- Added category & type upload presets for images (**NOW WORKING**)

# 12/2/2026
- Updated product repository, provider, as well as changes home_screen to ConsumerStatefulWidget for dynamic data UI
- Updated all models with id field

# 13/2/2026
- Fetched and streamed products to home-screen
- Added category filtering to home-screen

# 14/2/2026
- Created and set up search screen with searchbar, filter screen to show products according to searchbar input
- Used **Shared_Preferences for caching of recent searches** which are displayed in search screen.
- Added additional filters to filter screen

# 15/2/2026
- Set up product_details_screen

# 16/2/2026
- Set up user auth for **google sign-in** and **EmailAndPassword** and session token with **shared_preferences**
- Set up cart and wishlist logic. [ updated cart MRP and created wishlist MRP ] yet to work

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

- flutter clean

# Quiz

- Stream<User?> authStateChanges() => \_auth.authStateChanges();
- auth_repository and provider
- signInWithEmailAndPassword, Normal sign in, google sign in connection
- final user = cred.user!;

# Optimisation

- Const to avoid rebuild
- Indexed stack for tabs to avoid rebuild and allow caching

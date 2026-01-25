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
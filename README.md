# ClassAssignments-Mobile
A Flutter mobile application for managing products with SQLite, Firebase authentication, and additional features like Bluetooth, battery monitoring, and contacts access. Built for Android and iOS, it demonstrates a multi-feature app with a clean UI and robust backend integration.

## Features

- **Product Management**:
    - Add, edit, and delete products stored in a local SQLite database.
    - Upload product images, stored in the app’s documents directory.
    - View product details and full-screen images with long-press.
    - Swipe-to-edit or swipe-to-delete products in a list.
- **Authentication**:
    - Firebase Authentication with Google Sign-In.
    - Sign-up and sign-in screens for user management.
    - User profile screen to view account details.
- **Monitoring**:
    - Battery level monitoring with notifications.
    - Bluetooth device scanning and connectivity.
    - Network connectivity status updates.
- **Contacts**:
    - Access and display device contacts with permission handling.
- **Calculator**:
    - Basic calculator for quick computations.
- **Dashboard**:
    - Centralized home screen with navigation to all features.
- **Theme**:
    - Toggle between light and dark themes, persisted with SharedPreferences.

## Project Structure

 ```
 class_assignments/
 ├── android/                    # Android-specific files
 │   ├── app/
 │   │   ├── build.gradle.kts    # Gradle build configuration (Kotlin DSL)
 │   │   ├── google-services (1).json  # Firebase configuration
 │   │   ├── src/main/
 │   │   │   ├── AndroidManifest.xml  # Android app manifest
 │   │   │   ├── kotlin/com/example/class_assignments/
 │   │   │   │   ├── MainActivity.kt  # Main Android activity
 ├── ios/                       # iOS-specific files
 ├── lib/                       # Flutter source code
 │   ├── helpers/
 │   │   ├── theme_helper.dart  # Theme management (light/dark mode)
 │   ├── models/
 │   │   ├── product.dart       # Product model for SQLite
 │   ├── screens/
 │   │   ├── add_product_screen.dart  # Add/edit product UI
 │   │   ├── calculator_screen.dart   # Calculator UI
 │   │   ├── contacts_screen.dart     # Contacts list UI
 │   │   ├── dashboard_screen.dart    # Dashboard UI
 │   │   ├── home_screen.dart         # Main navigation
 │   │   ├── product_list_screen.dart # Product list with CRUD
 │   │   ├── profile_screen.dart      # User profile UI
 │   │   ├── sign_in_screen.dart      # Firebase sign-in UI
 │   │   ├── sign_up_screen.dart      # Firebase sign-up UI
 │   ├── services/
 │   │   ├── auth_service.dart        # Firebase auth logic
 │   │   ├── battery_service.dart     # Battery monitoring
 │   │   ├── bluetooth_service.dart   # Bluetooth scanning
 │   │   ├── connectivity_service.dart # Network status
 │   │   ├── database_helper.dart     # SQLite database operations
 │   ├── main.dart                    # App entry point
 ├── pubspec.yaml                     # Flutter dependencies
 ├── README.md                        # Project documentation
 ├── .gitignore                       # Git ignore rules
 ├── firebase.json                    # Firebase CLI configuration
 ├── test/                            # Unit tests
 ├── web/                             # Web app assets
 ├── linux/, macos/, windows/         # Platform-specific code
 ```

## How It Works

1. **Launch**:
    - The app starts at `main.dart`, initializing Firebase (`firebase_core`) and setting up the `MaterialApp`.
    - `home_screen.dart` provides a bottom navigation bar to access Dashboard, Calculator, Contacts, Products, and Profile.
2. **Authentication**:
    - Users sign in via `sign_in_screen.dart` using Google Sign-In (`firebase_auth`, `google_sign_in`).
    - `sign_up_screen.dart` allows new user registration.
    - `auth_service.dart` manages auth state and redirects to `home_screen.dart` on successful login.
3. **Product Management**:
    - `product_list_screen.dart` displays products from SQLite (`database_helper.dart`).
    - Users add/edit products via `add_product_screen.dart`, including image uploads (`image_picker`).
    - Products are stored in `products.db` (`sqflite`), with images in `/data/user/0/com.example.class_assignments/app_flutter/product_images`.
    - Swipe to edit/delete, long-press to view images full-screen.
4. **Monitoring**:
    - `battery_service.dart` uses `battery_plus` to monitor battery levels and show notifications (`flutter_local_notifications`).
    - `bluetooth_service.dart` scans devices (`flutter_blue_plus`).
    - `connectivity_service.dart` checks network status (`connectivity_plus`).
5. **Contacts**:
    - `contacts_screen.dart` lists device contacts (`flutter_contacts`, `permission_handler`).
6. **Calculator**:
    - `calculator_screen.dart` provides a simple calculator UI.
7. **Theme**:
    - `theme_helper.dart` toggles light/dark mode, saved via `shared_preferences`.
8. **Notifications**:
    - Firebase Cloud Messaging (`firebase_messaging`) handles push notifications.

## Setup Instructions

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/amazezerti/ClassAssignments-Mobile-.git
   cd ClassAssignments-Mobile-
   ```
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Configure Firebase**:
    - Ensure `android/app/google-services (1).json` and `lib/firebase_options.dart` are in the repository.
    - If missing, download `google-services.json` from [Firebase Console](https://console.firebase.google.com/) (Project Settings > Your apps > Android).
    - Generate `firebase_options.dart`:
      ```bash
      dart pub global activate flutterfire_cli
      flutterfire configure
      ```
    - Select your Firebase project and platforms (Android/iOS).
4. **Set Up JDK**:
    - Install JDK 17 from [Adoptium](https://adoptium.net/temurin/releases/?version=17).
    - Set `JAVA_HOME` environment variable to `C:\Program Files\Eclipse Adoptium\jdk-17.0.12.7-hotspot`.
    - Add `%JAVA_HOME%\bin` to `Path`.
    - Verify:
      ```bash
      java -version
      ```
5. **Run the App**:
   ```bash
   flutter run
   ```
    - Select a device/emulator.
    - Sign in with Google, navigate to “Products”, and test CRUD operations.

## Troubleshooting

### Gradle JDK Error
If you encounter `org.gradle.java.home is invalid`:
- Open `android/gradle.properties` and remove or correct:
  ```
  org.gradle.java.home=C\:Program Files/Java/jdk-17
  ```
  to:
  ```
  org.gradle.java.home=C:\Program Files\Eclipse Adoptium\jdk-17.0.12.7-hotspot
  ```
- In Android Studio:
    - File > Settings > Build, Execution, Deployment > Build Tools > Gradle.
    - Set “Gradle JDK” to JDK 17 or “Embedded JDK”.
- Run:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

### Firebase Errors
- Ensure `google-services (1).json` is in `android/app/`.
- Verify `firebase_options.dart` matches your Firebase project.
- Check Firebase Console for correct app configuration.

## Dependencies
- `flutter`: Flutter SDK
- `firebase_core`, `firebase_auth`, `google_sign_in`, `firebase_messaging`: Firebase integration
- `sqflite`, `path_provider`: SQLite database
- `image_picker`: Image uploads
- `flutter_local_notifications`: Notifications
- `battery_plus`, `connectivity_plus`, `flutter_blue_plus`: Monitoring
- `flutter_contacts`, `permission_handler`: Contacts access
- `shared_preferences`: Theme persistence

## Notes
- The repository includes sensitive files (`google-services (1).json`, `firebase_options.dart`). If public, consider making it private or regenerating Firebase credentials.
- Tested with Flutter 3.x, Gradle 8.7, and JDK 17.


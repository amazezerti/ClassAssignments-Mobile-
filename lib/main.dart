import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'screens/sign_in_screen.dart';
import 'screens/home_screen.dart';
import 'services/connectivity_service.dart';
import 'services/battery_service.dart';
import 'services/bluetooth_service.dart';
import 'helpers/theme_helper.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  final AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> showNotification(String title, String body, String channelId) async {
  final androidDetails = AndroidNotificationDetails(
    channelId,
    channelId,
    channelDescription: 'Notifications for $channelId',
    importance: Importance.max,
    priority: Priority.high,
  );
  final platformDetails = NotificationDetails(android: androidDetails);
  await flutterLocalNotificationsPlugin.show(0, title, body, platformDetails);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await initLocalNotifications();

  final isDarkMode = await ThemeHelper.loadTheme();
  final connectivityService = ConnectivityService();
  final batteryService = BatteryService();
  final bluetoothService = BluetoothService();

  connectivityService.startListening();
  batteryService.startBatteryMonitoring();
  bluetoothService.startBluetoothMonitoring();

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  const MyApp({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() async {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    await ThemeHelper.saveTheme(_isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontSize: 16),
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AuthChecker(toggleTheme: _toggleTheme),
    );
  }
}

class AuthChecker extends StatelessWidget {
  final VoidCallback toggleTheme;
  const AuthChecker({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.hasData
            ? HomeScreen(toggleTheme: toggleTheme)
            : SignInScreen(toggleTheme: toggleTheme);
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:honours_project/api/firebase_api.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//Background notification handler for firebaseMessaging
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

//Plugin to show flutter local notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//App initialisation
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase initialisation with platform specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

//Loads and sets local timezones for setting up notifications
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Europe/London'));

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//Configures local notications for Android
  const AndroidInitializationSettings initialisationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initialisationSettings = InitializationSettings(
    android: initialisationSettingsAndroid,
  );

//Initialises local notifications plugin
//Handles user taps on notification
  await flutterLocalNotificationsPlugin.initialize(initialisationSettings,
      onSelectNotification: (String? payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Received foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      print('Notification Title: ${message.notification?.title}');
      print('Notification Body: ${message.notification?.body}');
    }
  });

  await FirebaseInitService().initialize();
  runApp(MyApp());
}

//Sets up app theme and routing
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kScaffoldColor,
        appBarTheme: AppBarTheme(
          backgroundColor: kScaffoldColor,
          elevation: 0,
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: kTextColor,
            fontFamily: 'Roboto',
          ),
          titleSmall: TextStyle(
            fontSize: 12,
            color: kTextColor,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            color: kTextColor,
          ),
          bodySmall: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: kPrimaryColor,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kTextLightColor,
              width: 0.7,
            ),
          ),
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: kTextLightColor)),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}

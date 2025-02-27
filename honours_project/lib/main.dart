import 'package:flutter/material.dart';
import 'package:honours_project/api/firebase_api.dart';
import 'routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'constants.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print('Received foreground message: ${message.notification?.title}');

    if(message.notification != null){
      print('Notification Title: ${message.notification?.title}');
      print('Notification Body: ${message.notification?.body}');
    }
  });
  
  await FirebaseInitService().initialize();
  runApp(MyApp());
}

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

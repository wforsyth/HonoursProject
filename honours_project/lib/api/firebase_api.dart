import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase_options.dart';

class FirebaseInitService {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    } on Exception catch (e) {
      print('Error requesting permission: $e');
    }
  }
}

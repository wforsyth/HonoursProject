import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

//Signs user in through firebase authentication
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

//Creates a user and adds them to firebase authentication and firestore database collection
  Future<void> createUserWithEmailAndPassword({
    required String firstName,
    required String surname,
    required String email,
    required String password,
  }) async {
    try {
      List<String> signInMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (signInMethods.isNotEmpty) {
        throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Email address in use by another account');
      }

      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'surname': surname,
        'email': email,
        'reminders': []
      });
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

//Updates reminders object variable in database with relevant information
  Future<void> createReminder({
    required String medicineName,
    required String dosage,
    required String reminderTime,
    required String reminderDate,
    required String duration,
  }) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      Map<String, dynamic> eventData = {
        'medicineName': medicineName,
        'dosage': dosage,
        'reminderTime': reminderTime,
        'reminderDate': reminderDate,
        'duration': duration,
      };

      await _firestore.collection('users').doc(uid).update({
        'reminders': FieldValue.arrayUnion([eventData]),
      });
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

//Gets the usernames of users to display when signed in
  Future<Map<String, String>> getUserName() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        String firstName = userDoc['firstName'];
        String surname = userDoc['surname'];

        return {
          'firstName': firstName,
          'surname': surname,
        };
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e) {
      throw Exception('Error fetching user name: $e');
    }
  }

//Gets reminders from reminders object to be displayed in calendar
  Future <List<Map<String, dynamic>>> getReminders() async{
    try{
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if(userDoc.exists){
        List<dynamic> reminders = userDoc['reminders'];
        return reminders.cast<Map<String, dynamic>>();
      } else{
        throw Exception('User not found in database');
      }
    } catch(e){
      throw Exception('Error fetching reminders: $e');
    }
  }

//signs user out 
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

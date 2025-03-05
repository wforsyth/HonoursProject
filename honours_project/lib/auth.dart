import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:honours_project/models/medicine_type.dart';
import 'package:uuid/uuid.dart';

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
        'reminders': [],
        'journalEntries': [],
        'data': {},
      });
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

//Updates reminders object variable in database with relevant information
  Future<void> createReminder({
    required String medicineName,
    required MedicineType medicineType,
    required String dosage,
    required String reminderTime,
    required String reminderDate,
    required String interval,
    required String duration,
  }) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String medicineTypeString = medicineType.toString().split('.').last;
      String reminderId = Uuid().v4();
      String status = '';
      Map<String, dynamic> eventData = {
        'reminderId': reminderId,
        'medicineName': medicineName,
        'medicineType': medicineTypeString,
        'dosage': dosage,
        'reminderTime': reminderTime,
        'reminderDate': reminderDate,
        'interval': interval,
        'duration': duration,
        'status': status
      };

      await _firestore.collection('users').doc(uid).update({
        'reminders': FieldValue.arrayUnion([eventData]),
      });
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  //Updates reminders object variable in database with relevant information
  Future<void> createJournalEntry({
    required String time,
    required String date,
    required String description,
  }) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      Map<String, dynamic> eventData = {
        'time': time,
        'date': date,
        'description': description,
      };

      await _firestore.collection('users').doc(uid).update({
        'journalEntries': FieldValue.arrayUnion([eventData]),
      });
    } catch (e) {
      throw Exception('Error creating journal entry: $e');
    }
  }

  //Gets entries from journalEntries object to be displayed in calendar
  Future<List<Map<String, dynamic>>> getJournalEntries() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        List<dynamic> entries = userDoc['journalEntries'];
        return entries.cast<Map<String, dynamic>>();
      } else {
        throw Exception('User not found in database');
      }
    } catch (e) {
      throw Exception('Error fetching entries: $e');
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
  Future<List<Map<String, dynamic>>> getReminders() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        List<dynamic> reminders = userDoc['reminders'];
        return reminders.cast<Map<String, dynamic>>();
      } else {
        throw Exception('User not found in database');
      }
    } catch (e) {
      throw Exception('Error fetching reminders: $e');
    }
  }

//Function to delete reminder from firestore database
  Future<void> deleteReminder(String reminderId) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      List<dynamic> reminders = userDoc['reminders'];

      Map<String, dynamic>? deleteReminder;
      for (var reminder in reminders) {
        if (reminder['reminderId'] == reminderId) {
          deleteReminder = reminder;
          break;
        }
      }

      if (deleteReminder != null) {
        await _firestore.collection('users').doc(uid).update({
          'reminders': FieldValue.arrayRemove([deleteReminder]),
        });
      } else {
        throw Exception('Reminder not found');
      }
    } catch (e) {
      throw Exception('Error removing reminder: $e');
    }
  }

//Function to update status variable based on whether medication was taken or not
  Future<void> updateReminderStatus(String status, String reminderId) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      List<dynamic> reminders = userDoc['reminders'];

      for (var reminder in reminders) {
        if (reminder['reminderId'] == reminderId) {
          reminder['status'] = status;
          break;
        }
      }

      await _firestore.collection('users').doc(uid).update({
        'reminders': reminders,
      });
    } catch (e) {
      print('Error updating reminders status: $e');
    }
  }

//Function to update missed and taken data in database based on status 
  Future<void> updateData(bool isTaken) async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      DateTime now = DateTime.now();
      String month = '${now.month.toString().padLeft(2, '0')} ${now.year}';
      DocumentReference userDocRef = _firestore.collection('users').doc(uid);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userDocRef);

        if (!userSnapshot.exists) {
          throw Exception('User document does not exist');
        }

        Map<String, dynamic> data = userSnapshot.data() as Map<String, dynamic>;
        Map<String, dynamic> medicationData = data['data'] ?? {};
        Map<String, dynamic> monthData =
            medicationData[month] ?? {'taken': 0, 'missed': 0};

        if (isTaken) {
          monthData['taken'] += 1;
        } else {
          monthData['missed'] += 1;
        }

        medicationData[month] = monthData;
        transaction.update(userDocRef, {'data': medicationData});
      });
    } catch (e) {
      throw Exception('Error updating data: $e');
    }
  }

//signs user out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String firstName,
    required String surname,
    required String email,
    required String password,
  }) async {
    try{
      List<String> signInMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if(signInMethods.isNotEmpty){
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email address in use by another account');
      }
      
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'firstName': firstName,
        'surname': surname,
        'email': email,
        'medication': {}
      });
    } catch (e){
      throw Exception('Error creating user: $e');
    }
  }

  Future<Map<String, String>> getUserName() async {
    try{
      String uid = _firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists){
        String firstName = userDoc['firstName'];
        String surname = userDoc['surname'];

        return{
          'firstName': firstName,
          'surname': surname,
        };
      } else {
        throw Exception('User not found in Firestore');
      }
    } catch (e){
      throw Exception('Error fetching user name: $e');
    }
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }
}
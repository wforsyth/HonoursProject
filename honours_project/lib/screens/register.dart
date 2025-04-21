import 'package:flutter/material.dart';
import 'package:honours_project/constants.dart';
import 'package:honours_project/routes.dart';
import '../auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String firstName = '';
  String surname = '';

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerFirstName = TextEditingController();
  final TextEditingController controllerSurname = TextEditingController();

//Registers user using function from auth
//Takes information from controllers and enters into firebase auth and firestore
//Navigates user to log in page after
  Future<void> register() async {
    try {
      await Auth().createUserWithEmailAndPassword(
        firstName: controllerFirstName.text,
        surname: controllerSurname.text,
        email: controllerEmail.text,
        password: controllerPassword.text,
      );

      Navigator.pushNamed(context, AppRoutes.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An unknown error occured: $e'),
      ));
    }
  }

//Displays first name, surname, email, and password form for user to fill in
//Creates new user account based on valid information
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: controllerFirstName,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  firstName = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: controllerSurname,
                decoration: InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
                onSaved: (value) {
                  surname = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: controllerEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: controllerPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    register();
                  }
                },
                child: const Text('Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOtherColor,
                  foregroundColor: Colors.black,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

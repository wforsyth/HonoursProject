import 'package:flutter/material.dart';
import '../auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:honours_project/constants.dart';

class EmergencyContact extends StatefulWidget {
  @override
  _EmergencyContactState createState() => _EmergencyContactState();
}

class _EmergencyContactState extends State<EmergencyContact> {
  String name = '';
  String tele = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
  }

//Loads emergency contact details from database
  Future<void> _loadEmergencyContact() async{
    try{
      Auth auth = Auth();
      List<Map<String, dynamic>> emergencyContact = await auth.getEmergencyContact();

      if (emergencyContact.isNotEmpty){
        setState((){
          name = emergencyContact[0]['name'];
          tele = emergencyContact[0]['tele'];
          email = emergencyContact[0]['email'];
        });
      } else{
        setState((){
          name = '';
          tele = '';
          email = '';
        });
      }
    } catch (e){
      throw Exception ('Error getting emergency contact: $e');
    }
  }

//Pop-up input dialog used to input emergency contact name, phone number, and email address
//Information extracted from controller to then be entered into backend database encrypted
  void _showInputDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _teleController = TextEditingController();
    final _emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Enter Emergency Contact Details'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                TextField(
                  controller: _teleController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      tele = value;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                Auth auth = Auth();
                await auth.createEmergencyContact(
                    name: _nameController.text,
                    tele: _teleController.text,
                    email: _emailController.text);
                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Emergency contact saved!')),
                );

                _loadEmergencyContact();
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                foregroundColor: kScaffoldColor,
                backgroundColor: kOtherColor,
              ),
            ),
          ],
        );
      },
    );
  }

//Launches users default email app using mailto
  Future<void> _sendEmail(String email) async {
    try {
      var url = Uri.parse("mailto:$email");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw Exception('Error sending email: $e');
    }
  }

//Launches users default texting app using sms
  Future<void> _sendText(String text) async {
    try {
      var url = Uri.parse("sms:$text");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      throw Exception('Error sending text: $e');
    }
  }

//Loads emergency contact email from database
//Enters details into default email app if email exists
  Future<void> getSendEmail() async {
    try {
      Auth auth = Auth();
      List<Map<String, dynamic>> emergencyContact =
          await auth.getEmergencyContact();

      if (emergencyContact.isNotEmpty) {
        String email = emergencyContact[0]['email'];
        _sendEmail(email);
      } else {
        throw Exception('No emergency contact found');
      }
    } catch (e) {
      throw Exception('Error getting emergency contact: $e');
    }
  }

//Loads emergency contact phone number from database
//Enters details into default texting app if phone number exists
  Future<void> getSendText() async {
    try {
      Auth auth = Auth();
      List<Map<String, dynamic>> emergencyContact =
          await auth.getEmergencyContact();

      if (emergencyContact.isNotEmpty) {
        String text = emergencyContact[0]['tele'];
        _sendText(text);
      } else {
        throw Exception('No emergency contact found');
      }
    } catch (e) {
      throw Exception('Error getting emergency contact: $e');
    }
  }

//Main widget that displays either text stating that no emergency contact has been added
//Or two red buttons for either texting or emailing emergency contact
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: name.isEmpty || tele.isEmpty || email.isEmpty
            ? Text('No emergency contact added.')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size(200, 60),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: getSendEmail,
                    child: Text('Send Email', style: TextStyle(fontSize: 18)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      minimumSize: Size(200, 60),
                      foregroundColor: Colors.black,
                    ),
                    onPressed: getSendText,
                    child: Text('Send Text', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showInputDialog(context),
        child: Icon(Icons.contact_emergency),
        backgroundColor: kPrimaryColor,
        foregroundColor: kScaffoldColor,
        tooltip: 'Add Emergency Contact',
      ),
    );
  }
}

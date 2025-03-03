import 'package:flutter/material.dart';
import 'package:honours_project/routes.dart';
import 'package:honours_project/screens/emergencyContact.dart';
import 'stats.dart'; 
import 'epilepsyJournal.dart'; 
import 'overview.dart'; 
import 'package:firebase_auth/firebase_auth.dart';
import '../auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  final User? user = Auth().currentUser;

  Future<void> signOut() async{
    await Auth().signOut();
  }

  Widget _userId() {
    return Text(user?.email ?? 'User email');
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _firstName;
  String? _surname;

  final List<Widget> _screens = [
    Overview(),
    EpilepsyJournal(),
    Stats(),
    EmergencyContact(),
  ];

  Future<void> _fetchUserName() async{
    Map<String, String> details = await Auth().getUserName();
    setState((){
      _firstName = details['firstName'];
      _surname = details['surname'];
    });
  }

  void initState() {
    super.initState();
    _fetchUserName();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Epialarm'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('$_firstName $_surname'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 6),
            ListTile(
              title: Text('Logout'),
              onTap: (){
                widget.signOut();
                Navigator.of(context).pop();
                Navigator.pushNamed(context, AppRoutes.login);
              },
            ),
          ]
        )
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart_rounded),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_emergency),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}
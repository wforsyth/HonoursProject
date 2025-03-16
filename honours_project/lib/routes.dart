import 'package:flutter/material.dart';
import 'package:honours_project/screens/emergencyContact.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/stats.dart';
import 'screens/epilepsyJournal.dart';
import 'screens/overview.dart';
import 'screens/medEntry.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String stats = '/stats';
  static const String epilepsyJournal = '/epilepsyJournal';
  static const String overview = '/overview';
  static const String medEntry = '/medEntry';
  static const String emergencyContact = '/emergencyContact';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => HomeScreen(),
    stats: (context) => Stats(),
    epilepsyJournal: (context) => EpilepsyJournal(),
    overview: (context) => Overview(),
    medEntry: (context) => MedEntry(),
    emergencyContact: (context) => EmergencyContact(),
  };
}

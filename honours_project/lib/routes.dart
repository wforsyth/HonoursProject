import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';
import 'screens/home.dart';
import 'screens/medicationReminder.dart';
import 'screens/epilepsyJournal.dart';
import 'screens/overview.dart';
import 'screens/medEntry.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String medicationReminder= '/medicationReminder';
  static const String epilepsyJournal= '/epilepsyJournal';
  static const String overview = '/overview';
  static const String medEntry = '/medEntry';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    home: (context) => HomeScreen(),
    medicationReminder: (context) => MedicationReminder(),
    epilepsyJournal: (context) => EpilepsyJournal(),
    overview: (context) => Overview(),
    medEntry: (context) => MedEntry(),
  };
}
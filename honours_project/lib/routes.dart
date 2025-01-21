import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/register.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
  };
}
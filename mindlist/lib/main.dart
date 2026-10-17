import 'package:flutter/material.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services here (Firebase, local storage, etc.)
  // await Firebase.initializeApp();

  runApp(const MyApp());
}
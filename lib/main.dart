import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import './login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Collection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoaderOverlay(child: LoginView()),
    );
  }
}

// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter_flipperkit/flutter_flipperkit.dart';

import './login.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // FlipperClient flipperClient = FlipperClient.getDefault();

  // flipperClient.addPlugin(FlipperNetworkPlugin());
  // flipperClient.addPlugin(FlipperSharedPreferencesPlugin());
  // // flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin());
  // flipperClient.addPlugin(FlipperReduxInspectorPlugin());
  // flipperClient.start();

  /* 
    * Additional function call to ensure widgets flutter binding is initialized,
    * but the issue still happens if no delay task below.
  */

  WidgetsFlutterBinding.ensureInitialized();

  /* 
    * This will make splash screen lasts for the duration of the delay task.
    * 300ms looks well for me, can adjust based on your preference.
  */

  await Future.delayed(const Duration(milliseconds: 600));

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

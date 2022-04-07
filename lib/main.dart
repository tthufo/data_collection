// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
// import 'package:flutter_flipperkit/flutter_flipperkit.dart';

import './login.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // FlipperClient flipperClient = FlipperClient.getDefault();

  // flipperClient.addPlugin(FlipperNetworkPlugin());
  // flipperClient.addPlugin(FlipperSharedPreferencesPlugin());
  // // flipperClient.addPlugin(new FlipperDatabaseBrowserPlugin());
  // flipperClient.addPlugin(FlipperReduxInspectorPlugin());
  // flipperClient.start();

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

import 'package:flutter/material.dart';

class CivilView extends StatelessWidget {
  final String title;

  const CivilView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Option(),
      ),
    );
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('1'));
  }
}

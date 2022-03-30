import 'package:flutter/material.dart';

class Checker extends StatefulWidget {
  final Function(Map<String, dynamic>) onChange;
  final Map<String, dynamic> obj;

  const Checker({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Checker> {
  bool checkedValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget header() {
    return Row(
      children: [
        SizedBox(
            height: 25.0,
            width: 25.0,
            child: Checkbox(
              checkColor: Colors.white,
              activeColor: Colors.greenAccent,
              value: checkedValue,
              onChanged: (bool? value) {
                setState(() {
                  checkedValue = !checkedValue;
                });
              },
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          widget.obj['title'],
          maxLines: 2,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(5), child: header());
  }
}

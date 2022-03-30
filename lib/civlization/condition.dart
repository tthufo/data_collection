import 'package:flutter/material.dart';
import '../component/textfield.dart';

class ConditionView extends StatefulWidget {
  final Function(Map<String, dynamic>) onChange;
  final Map<String, dynamic> obj;

  const ConditionView({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ConditionView> {
  bool checkedValue = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Column header() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: FieldView(
              obj: {
                "start": "Số người",
                "end": "người",
                "text": widget.obj['peopleNo'],
                "type": TextInputType.number,
              },
              onChange: (texting) {
                setState(() {});
              }),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FieldView(
                  obj: {
                    "pre": "Trong đó:",
                    "start": "Nam",
                    "end": "người",
                    "text": widget.obj['maleNo'],
                    "type": TextInputType.number,
                  },
                  onChange: (texting) {
                    setState(() {});
                  }),
              FieldView(
                  obj: {
                    "pre": "Trong đó:",
                    "hiddenPre": "1",
                    "start": "   Nữ",
                    "end": "người",
                    "text": widget.obj['femaleNo'],
                    "type": TextInputType.number,
                  },
                  onChange: (texting) {
                    setState(() {});
                  })
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
        child: header());
  }
}

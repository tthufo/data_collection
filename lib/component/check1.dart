import 'package:flutter/material.dart';

class CheckCard1 extends StatefulWidget {
  final String title;

  final Map<String, dynamic> obj;

  final Function(Map<String, dynamic>) onSelectionChanged;

  const CheckCard1(
      {Key? key,
      required this.title,
      required this.obj,
      required this.onSelectionChanged})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CheckCard1> {
  String _selectedGender = '0';

  bool checkedValue = false;

  String birthDay = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Padding card(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.title,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0)),
            radios_2(),
          ],
        ));
  }

  Row radios_2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: '0',
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Kiên cố',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: '1',
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Bán kiên cố',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: '2',
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Đơn sơ',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return card(context);
  }
}

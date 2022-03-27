import 'package:flutter/material.dart';

class CheckCard extends StatefulWidget {
  final String title;

  final Map<String, dynamic> obj;

  final Function(Map<String, dynamic>) onSelectionChanged;

  const CheckCard(
      {Key? key,
      required this.title,
      required this.obj,
      required this.onSelectionChanged})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CheckCard> {
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
            radios_1(),
            radios_3(),
          ],
        ));
  }

  Row radios_1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Radio<String>(
                value: '3',
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
                'Nhà văn hóa',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Radio<String>(
                value: '4',
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
                'Nhà kết hợp sơ tán dân',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        )
      ],
    );
  }

  Row radios_3() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Row(
            children: [
              Radio<String>(
                value: '5',
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
                'Hồ chưa',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Radio<String>(
                value: '6',
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
                'Công trình PCTT khác',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        )
      ],
    );
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
                'Nhà ở',
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
                'Trường học',
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
                'Trạm y tế',
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

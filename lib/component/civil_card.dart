import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CivilCard extends StatefulWidget {
  final String title;

  final Map<String, dynamic> obj;

  final Function(Map<String, dynamic>) onSelectionChanged;

  const CivilCard(
      {Key? key,
      required this.title,
      required this.obj,
      required this.onSelectionChanged})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CivilCard> {
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

  Card card(BuildContext context) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(widget.title),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Text("Sinh năm:"),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                      height: 30,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(4.0)),
                                      child: Text(birthDay))))
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 1, child: radios()),
                    Container(
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.greenAccent,
                            value: checkedValue,
                            onChanged: (bool? value) {
                              setState(() {
                                checkedValue = !checkedValue;
                                widget.obj['bla'] = "blarrrrhr";
                                widget.onSelectionChanged(widget.obj);
                              });
                            },
                          ),
                          const Text(
                            'Khuyết tật',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )));
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthDay = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  Row radios() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Radio<String>(
                value: '0',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Nam',
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
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Nữ',
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../component/civil_card.dart';

class CivilView extends StatelessWidget {
  final String title;

  const CivilView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(child: Center(child: Option()));
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> rowData = <dynamic>[];

  String _selectedGender = '0';

  bool checkedValue = false;

  String birthDay = "";

  var people1 = {
    'name': 'pter',
    'age': 20,
    'bla': '',
  };

  Map<String, dynamic> obj = {
    'name': 'pter',
    'age': 20,
    'bla': '',
  };

  @override
  void initState() {
    super.initState();
    setState(() {
      rowData = [1, 2, 3];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  Column header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
            child: Text(
              'Hộ số: 001',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttoning(onClickAction: () => {print(obj)}),
            Expanded(
                flex: 1,
                child: Row(children: [
                  Text(
                    'Kinh độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text('12.', maxLines: 1)),
                ])),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: Row(children: [
                  Text(
                    'Vĩ độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text('12.1436332434', maxLines: 1)),
                ])),
          ],
        ),
        Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.greenAccent,
                  value: checkedValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedValue = !checkedValue;
                    });
                  },
                ),
                Text(
                  obj['obj'],
                  style: TextStyle(fontSize: 14),
                )
              ],
            ))
      ],
    );
  }

  Container buttoning({required Function onClickAction}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            child: SizedBox(
              width: 100,
              height: 35,
              child: MaterialButton(
                minWidth: 60,
                height: 40,
                onPressed: () {
                  onClickAction();
                },
                child: const Text(
                  "Nhận tọa độ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.greenAccent,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )));
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
                      child: Text("Người thứ 1 (chủ hộ):"),
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

  Widget body(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15.0),
            header(),
            card(context),
            CivilCard(
              title: 'ahii',
              obj: obj,
              onSelectionChanged: (selectedItem) {
                setState(() {
                  obj = selectedItem;
                });
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  bool get wantKeepAlive => true;
}

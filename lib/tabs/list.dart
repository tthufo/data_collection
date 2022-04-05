import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/storage.dart';

class Listing extends StatelessWidget {
  final String title;

  const Listing({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // set it to false
        appBar: AppBar(
          title: const Text("Danh sách"),
          automaticallyImplyLeading: true,
        ),
        body: const Option());
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

  @override
  void initState() {
    super.initState();
    _initData('civil');
  }

  void _initData(type) async {
    var list = await Storing().getAllData(type) ?? [];
    setState(() {
      rowData = list;
    });
    print(list);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Row radios() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 1,
            child: Row(children: [
              Radio<String>(
                value: '0',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                  _initData('civil');
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Danh sách dân cư',
                style: TextStyle(fontSize: 14),
              ),
            ])),
        Expanded(
            flex: 1,
            child: Row(children: [
              Radio<String>(
                value: '1',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                  _initData('school');
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'Danh sách công trình',
                style: TextStyle(fontSize: 14),
              ),
            ])),
      ],
    );
  }

  Widget card(object, pos) {
    var data = object['data'];
    var id = object['id'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Image.asset("images/img_logos.png",
                    height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedGender == "0" ? "Hộ" : "Trường"} số ${id}',
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Expanded(
                          flex: 1,
                          child: Row(children: [
                            const Text(
                              'K.dộ:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                                child: Text(data['coordinate']['lat'],
                                    maxLines: 1)),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(children: [
                            const Text(
                              'V.độ:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                                child: Text(data['coordinate']['long'],
                                    maxLines: 1)),
                          ]))
                    ])
                  ],
                )),
            DropdownButton<String>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              items: <String>['Tải lên', 'Xóa'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (opt) {
                if (opt == "Tải lên") {
                } else {
                  Storing().delDataAt(
                      pos, _selectedGender == "0" ? "civil" : "school");
                  _initData(_selectedGender == "0" ? "civil" : "school");
                }
              },
            )
            // const Expanded(flex: 1, child:
            //  Icon(Icons.more_vert)
            //  )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        radios(),
        Expanded(
            child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: rowData.length,
          itemBuilder: (context, pos) {
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: card(jsonDecode(rowData[pos]), pos),
                  ),
                ));
          },
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

import 'package:flutter/material.dart';
import 'dart:convert';
import './detail.dart';

class ResultView extends StatelessWidget {
  const ResultView(
      {Key? key,
      required this.data,
      required this.id,
      required this.name,
      required this.birthDay,
      required this.address})
      : super(key: key);

  final String data;

  final String id;

  final String name;

  final String birthDay;

  final String address;

  Container buttoning(
      BuildContext context, String title, String content, String status) {
    var coloring = (status == "2"
        ? Colors.green
        : status == "1"
            ? Colors.red
            : Colors.yellow);
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Material(
              borderRadius: BorderRadius.circular(0.0),
              color: Colors.white,
              child: Container(
                width: MediaQuery.of(context).size.width - 0,
                padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Text(title,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14.0))),
                      Expanded(
                          flex: 7,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Text(content,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: coloring,
                                      fontSize: 14.0)))),
                      Expanded(
                          flex: 1,
                          child: Image.asset(
                            status == "2"
                                ? 'images/green_check.png'
                                : status == "1"
                                    ? 'images/red_delete.png'
                                    : 'images/warning.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                          ))
                    ]),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(data);
    var information = json['face_item'];
    var fraudInformation = json["fraud_info"];
    var cardImage = json['front_image'];
    var backImage = json['back_image'];
    var faceImage = json['face_image'];
    var notMatch = information['match'] == "false";
    String naming = information['name'];
    String birthDayD = information['dob'];
    String addressD = information['address'];
    return //Scaffold(
        // appBar: AppBar(
        //   // leading: BackButton(onPressed: () {
        //   //   var nav = Navigator.of(context);
        //   //   nav.pop();
        //   //   nav.pop();
        //   // }),
        //   title: const Text("Thông tin xác thực"),
        //   automaticallyImplyLeading: true,
        // ),
        // body:
        SingleChildScrollView(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(margin: const EdgeInsets.all(50.0), child: const Text("")),
          buttoning(
              context,
              "Số CMT/ CCCD",
              information['id'],
              information['id'] == null
                  ? "3"
                  : information['id'] != id
                      ? "1"
                      : "2"),
          buttoning(
              context,
              "Họ và tên",
              naming,
              information['name'] == null
                  ? "3"
                  : (naming).toLowerCase() != name.toLowerCase()
                      ? "1"
                      : "2"),
          buttoning(
              context,
              "Ngày sinh",
              birthDayD,
              information['dob'] == null
                  ? "3"
                  : (birthDayD).toLowerCase() != birthDay.toLowerCase()
                      ? "1"
                      : "2"),
          buttoning(
              context,
              "Địa chỉ",
              addressD,
              information['address'] == null
                  ? "3"
                  : (addressD).toLowerCase() != address.toLowerCase()
                      ? "1"
                      : "2"),
          buttoning(
              context,
              "Độ xác thực",
              information['match'] == null
                  ? "-"
                  : notMatch
                      ? "Không trùng khớp"
                      : "Trùng khớp",
              information['match'] == null
                  ? "3"
                  : notMatch
                      ? "1"
                      : "2"),
          buttoning(
              context,
              "Độ tương đồng:",
              "${double.parse(information['percentage']) * 1} %",
              (information['match'] == null
                  ? "3"
                  : notMatch
                      ? "1"
                      : "2")),
          buttoning(
              context,
              "Độ chân thực:",
              "${fraudInformation['livenessMessage']}",
              (fraudInformation['faceSwapping'] == 'false' &&
                      fraudInformation['faceLiveness'] == 'false')
                  ? "2"
                  : "1"),
          const SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailView(
                            data: data,
                            id: id,
                            name: name,
                            birthDay: birthDay,
                            address: address)));
              },
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                      Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                        border: Border.all(color: Colors.lightBlueAccent)),
                    child: cardImage != ""
                        ? Image.memory(
                            const Base64Decoder().convert(cardImage),
                            width: (MediaQuery.of(context).size.width / 3) - 2,
                            height: (MediaQuery.of(context).size.width / 3) *
                                9 /
                                16,
                            fit: BoxFit.contain,
                          )
                        : const Text('')),
                Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                        border: Border.all(color: Colors.lightBlueAccent)),
                    child: backImage != ""
                        ? Image.memory(
                            const Base64Decoder().convert(backImage),
                            width: (MediaQuery.of(context).size.width / 3) - 2,
                            height: (MediaQuery.of(context).size.width / 3) *
                                9 /
                                16,
                            fit: BoxFit.contain,
                          )
                        : const Text('')),
                Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Colors.white,
                        border: Border.all(color: Colors.lightBlueAccent)),
                    child: faceImage != ""
                        ? Image.memory(
                            const Base64Decoder().convert(faceImage),
                            width: (MediaQuery.of(context).size.width / 3) - 2,
                            height: (MediaQuery.of(context).size.width / 3) *
                                9 /
                                16,
                            fit: BoxFit.contain,
                          )
                        : const Text(''))
              ])),
        ],
        //),
      )),
    );
  }
}

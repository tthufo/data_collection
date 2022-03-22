import 'package:flutter/material.dart';
import 'dart:convert';

class DetailView extends StatelessWidget {
  const DetailView(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        title: const Text("Thông tin chi tiết"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
          child: Detail(
              data: data,
              id: id,
              name: name,
              birthDay: birthDay,
              address: address)),
    );
  }
}

class Detail extends StatefulWidget {
  const Detail(
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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Detail> with WidgetsBindingObserver {
  String isFirst = "1";

  String isImage = "1";

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  Container buttoning(String title, {required Function onClickAction}) {
    return Container(
        child: Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: (MediaQuery.of(context).size.width / 2) - 100,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          onClickAction();
        },
        child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Montserrat', color: Colors.white, fontSize: 18.0)),
      ),
    ));
  }

  buttons() {
    return Row(children: [
      const SizedBox(width: 10),
      Expanded(
          child: buttoning("Ảnh", onClickAction: () {
            setState(() {
              isImage = "1";
            });
          }),
          flex: 4),
      const SizedBox(width: 10),
      Expanded(
          child: buttoning("Thông tin", onClickAction: () {
            setState(() {
              isImage = "2";
            });
          }),
          flex: 4),
      const SizedBox(width: 10),
    ]);
  }

  infor() {
    return Center(
        child: Column(children: [
      const SizedBox(height: 100),
      const Text("Thông tin CMT/CCCD",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17.0,
            color: Colors.lightBlueAccent,
          )),
      const SizedBox(height: 10),
      Text(
        "Số CMT/CCCD: ${widget.id}\nHọ và tên: ${widget.name}\nNgày tháng sinh: ${widget.birthDay}\nĐịa chỉ: ${widget.address}",
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 16.0,
          color: Colors.lightBlueAccent,
        ),
      ),
    ]));
  }

  main() {
    var json = jsonDecode(widget.data);
    var information = json['face_item'];
    var fraudInformation = json["fraud_info"];
    var informationBack = json['back_item'];
    var cardImage = json['front_image'];
    var backImage = json['back_image'];
    var faceImage = json['face_image'];
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15),
            const Text(
              "Thông tin mặt trước",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10.0),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      " Họ và tên: ${information['name']} \n Số CMT/CCCD: ${information['id']} \n Giới tính: ${information['sex']} \n Ngày tháng năm sinh: ${information['dob']} \n Quốc tịch: ${information['national']} \n Nguyên quán: ${information['domicile']} \n Địa chỉ: ${information['address']} \n Ngày hiệu lực: ${information['expire_date']} \n Tỉ lệ trùng khớp: ${double.parse(information['percentage']) * 1} % \n Trùng khớp: ${information['match'] == "false" ? "KHÔNG" : "CÓ"} \n Độ chân thực: ${fraudInformation['livenessMessage']}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.lightBlueAccent,
                          fontSize: 14.0),
                    ))),
            const Text(
              "Thông tin mặt sau",
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10.0),
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      " Dân tộc: ${informationBack['nation']} \n Tôn giáo: ${informationBack['religion']} \n Đặc điểm: ${informationBack['identifying_characteristics']} \n Ngày phát hành: ${informationBack['issue_date']}\n Nơi cấp: ${informationBack['issue_by']}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.lightBlueAccent,
                          fontSize: 14.0),
                    ))),
            Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: Colors.lightBlueAccent)),
                child: Image.memory(
                  const Base64Decoder().convert(isFirst == "1"
                      ? cardImage
                      : isFirst == "2"
                          ? backImage
                          : faceImage),
                  width: (MediaQuery.of(context).size.width / 1) - 2,
                  height: (MediaQuery.of(context).size.width / 1) * 9 / 16,
                  fit: BoxFit.contain,
                )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = "1";
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.lightBlueAccent)),
                      child: cardImage != ""
                          ? Image.memory(
                              const Base64Decoder().convert(cardImage),
                              width:
                                  (MediaQuery.of(context).size.width / 3) - 2,
                              height: (MediaQuery.of(context).size.width / 3) *
                                  9 /
                                  16,
                              fit: BoxFit.contain,
                            )
                          : const Text(''))),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = "2";
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.lightBlueAccent)),
                      child: backImage != ""
                          ? Image.memory(
                              const Base64Decoder().convert(backImage),
                              width:
                                  (MediaQuery.of(context).size.width / 3) - 2,
                              height: (MediaQuery.of(context).size.width / 3) *
                                  9 /
                                  16,
                              fit: BoxFit.contain,
                            )
                          : const Text(''))),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isFirst = "3";
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          border: Border.all(color: Colors.lightBlueAccent)),
                      child: faceImage != ""
                          ? Image.memory(
                              const Base64Decoder().convert(faceImage),
                              width:
                                  (MediaQuery.of(context).size.width / 3) - 2,
                              height: (MediaQuery.of(context).size.width / 3) *
                                  9 /
                                  16,
                              fit: BoxFit.contain,
                            )
                          : const Text('')))
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      const SizedBox(height: 10),
      buttons(),
      SingleChildScrollView(child: isImage == "1" ? main() : infor()),
    ]));
  }
}

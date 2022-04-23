import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:loader_overlay/loader_overlay.dart';
import '../component/buttoning.dart';
import '../util/information.dart';
import '../util/storage.dart';
import './edit.dart';

class InforView extends StatefulWidget {
  const InforView({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InforView> {
  var userInfor = {};

  @override
  initState() {
    super.initState();
    // context.loaderOverlay.show();
    didRequestInfo();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> didRequestInfo() async {
    var token = await Storing().getString('token');
    var postUri = Uri.parse("${Info.url}api/auth");
    var request = http.MultipartRequest(
      "GET",
      postUri,
    );

    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    context.loaderOverlay.hide();

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var responseObj = jsonDecode(responseString);

    if (response.statusCode != 200) {
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau');
      return;
    }
    if (responseObj['status'] == "OK") {
      print(responseObj);
      setState(() {
        userInfor = responseObj['data'];
      });
    } else {
      var error = responseObj['errors'][0];
      _showToast(error['message']);
    }
  }

  _showToast(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mess),
    ));
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Widget body() {
    return Column(
      children: [
        top(),
        Expanded(
            flex: 8,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    mid(),
                  ],
                )))),
        const Divider(
          height: 2,
          color: Colors.grey,
        ),
        Expanded(flex: 2, child: footer()),
      ],
    );
  }

  Widget top() {
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('images/img_bg_head.png'),
            width: MediaQuery.of(context).size.width,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 50),
          Column(children: [
            Text(userInfor['user_name'] ?? '-',
                style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            const Text("Quản trị viên",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  "THÔNG TIN CÁ NHÂN",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                )),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
          ]),
        ],
      ),
      Positioned(
          left: 5.0,
          top: 5.0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => {Navigator.pop(context)},
          )),
    ]);
  }

  Widget element(obj) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(obj['title'],
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(obj['detail'],
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ]));
  }

  Widget mid() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      element({'title': 'Họ và tên', 'detail': userInfor['user_name'] ?? '-'}),
      element({'title': 'Địa chỉ', 'detail': userInfor['unit'] ?? '-'}),
      element({'title': 'Email', 'detail': userInfor['email'] ?? '-'}),
      element({
        'title': 'Số điện thoại',
        'detail': userInfor['phone_number'] ?? '-'
      }),
    ]);
  }

  Widget footer() {
    return SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Buttoning(
              title: "Cập nhật thông tin",
              onClickAction: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditView()))
              },
              obj: {
                'bgColor': const Color.fromRGBO(39, 77, 158, 1),
                'titleColor': Colors.white,
                'width': MediaQuery.of(context).size.width - 30,
                'height': 50.0,
                'fontSize': 18.0,
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: const Image(
            image: AssetImage('images/img_bg_head.png'),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: LoaderOverlay(
            child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            Center(
              child: Center(child: body()),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width / 2) - 75,
              top: 50.0,
              child: const Image(
                image: AssetImage('images/img_Ava.png'),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        )));
  }
}

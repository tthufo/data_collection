import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../component/buttoning.dart';
import '../component/textfield.dart';
import 'package:flutter/services.dart';

import '../util/storage.dart';

class EditView extends StatelessWidget {
  const EditView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          flexibleSpace: const Image(
            image: AssetImage('images/img_bg_head.png'),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: const LoaderOverlay(child: Option()));
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 9,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    top(),
                    Container(
                      child: null,
                      height: 3,
                      color: Colors.grey,
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: const Text("THÔNG TIN CÁ NHÂN",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold))),
                    mid(),
                  ],
                )))),
        Expanded(flex: 2, child: footer()),
      ],
    );
  }

  Widget top() {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ảnh đại diện",
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Row(children: [
              Stack(
                children: [
                  const Image(
                    image: AssetImage('images/img_Ava.png'),
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 70,
                    top: 70,
                    child: const Image(
                      image: AssetImage('images/img_cam.png'),
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              const Text("Tài chột",
                  style: TextStyle(
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 5),
              const Image(
                image: AssetImage('images/img_edit.png'),
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              )
            ])
          ],
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

  Widget element(obj) {
    return Container(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(obj['title'],
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold))),
          FieldView(
              obj: {
                "limit": 100,
                "format": [FilteringTextInputFormatter.singleLineFormatter],
                "textAlign": TextAlign.left,
                "text": obj['detail'],
                "width": MediaQuery.of(context).size.width * 0.9,
                "height": 50.0,
                "fontSize": 18.0,
                "fontWeight": FontWeight.bold,
                "underLine": "1",
              },
              onChange: (texting) {
                if (texting.runtimeType != String) {
                } else {}
              })
        ]));
  }

  Widget mid() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      element({'title': 'Họ và tên', 'detail': 'Phạm Tài chột'}),
      element({'title': 'Họ và tên', 'detail': 'Phạm Tài chột'}),
      element({'title': 'Họ và tên', 'detail': 'Phạm Tài chột'}),
      element({
        'title': 'Họ và tên',
        'detail': 'Phạm Tài chộ s  sf asf sf asdf asf asf asf asf asf sft'
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
              title: "Lưu thông tin",
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
    return Center(
      child: body(),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _addingHouse(data, pos) async {
    var token = await Storing().getString('token');
    var postUri = Uri.parse("http://gisgo.vn:8016/api/household");
    var request = http.MultipartRequest(
      "POST",
      postUri,
    );

    // request.files.add(http.MultipartFile.fromBytes(
    //     'images', await File.fromUri(Uri.parse(imagePath)).readAsBytes(),
    //     contentType: MediaType('image', ext)));

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var responseObj = jsonDecode(responseString);

    context.loaderOverlay.hide();
    if (response.statusCode != 200) {
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau');
      return;
    }
    if (responseObj['status'] == "OK") {
      _showToast("Cập nhật hoàn thành");
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
}

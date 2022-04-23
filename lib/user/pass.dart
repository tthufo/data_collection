import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import '../component/buttoning.dart';
import '../component/textfield.dart';
import 'package:flutter/services.dart';

import '../util/storage.dart';
import '../util/information.dart';

class PassView extends StatelessWidget {
  const PassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Đổi mật khẩu"),
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
  var pass = {};

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
                    const SizedBox(height: 50),
                    mid(),
                  ],
                )))),
        Expanded(flex: 2, child: footer()),
      ],
    );
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
                "obscureText": '1',
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
                } else {
                  if (obj['title'] == "Mật khẩu cũ") {
                    setState(() {
                      pass['pass'] = texting;
                    });
                  }
                  if (obj['title'] == "Mật khẩu mới") {
                    setState(() {
                      pass['newPass'] = texting;
                    });
                  } else {
                    setState(() {
                      pass['reNewPass'] = texting;
                    });
                  }
                }
              })
        ]));
  }

  Widget mid() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      element({'title': 'Mật khẩu cũ', 'detail': ''}),
      element({'title': 'Mật khẩu mới', 'detail': ''}),
      element({'title': 'Nhập lại mật khẩu mới', 'detail': ''}),
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
              title: "Đổi mật khẩu",
              onClickAction: () => {
                FocusScope.of(context).requestFocus(FocusNode()),
                context.loaderOverlay.show(),
                _changePass(),
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
        child: GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: body(),
    ));
  }

  @override
  bool get wantKeepAlive => true;

  _changePass() async {
    var token = await Storing().getString('token');
    var postUri = Uri.parse("${Info.url}api/auth/password");

    final body = {
      'OldPasswd': pass['pass'],
      'NewPasswd': pass['newPass'],
      'ConfirmNewPasswd': pass['reNewPass'],
    };
    final jsonString = json.encode(body);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'Authorization': 'Bearer $token',
    };
    final response =
        await http.post(postUri, headers: headers, body: jsonString);
    var responseObj = jsonDecode(response.body);

    context.loaderOverlay.hide();
    if (response.statusCode != 200) {
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau');
      return;
    }
    if (responseObj['status'] == "OK") {
      _showToast("Cập nhật thành công");
      Navigator.pop(context);
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

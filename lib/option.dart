import 'package:flutter/material.dart';
import './component/buttoning.dart';
import './util/storage.dart';
import './civlization/civil.dart';
import './school/school.dart';
import './tabs/list.dart';
import './login.dart';
import './user/infor.dart';
import './user/pass.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import '../component/buttoning.dart';
import '../util/information.dart';
import '../util/storage.dart';

class OptionView extends StatelessWidget {
  const OptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: const Image(
            image: AssetImage('images/img_bg_head.png'),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          actions: [
            DropdownButton<String>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              items: <String>[
                'Thông tin tài khoản',
                'Đổi mật khẩu',
                'Đăng xuất'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (opt) {
                if (opt == "Thông tin tài khoản") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InforView()));
                } else if (opt == "Đổi mật khẩu") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PassView()));
                } else {
                  showAlertDialog(context);
                }
              },
            ),
            const SizedBox(width: 10)
          ],
        ),
        body: LoaderOverlay(
            child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            const Center(
              child: Center(child: MyHomePage()),
            )
          ],
        )));
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Bỏ qua"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Đăng xuất"),
      onPressed: () {
        didLogOut(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Thông báo"),
      content: const Text("Bạn có muốn đăng xuất khỏi tài khoản?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<dynamic> didLogOut(BuildContext context) async {
    context.loaderOverlay.show();

    var token = await Storing().getString('token');
    var postUri = Uri.parse("${Info.url}api/auth/logout");
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
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau', context);
      return;
    }
    if (responseObj['status'] == "OK") {
      Storing().logOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginView()));
    } else {
      var error = responseObj['errors'][0];
      _showToast(error['message'], context);
    }
  }

  _showToast(mess, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mess),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset("images/img_bg_head.png",
            //     height: 80,
            //     width: MediaQuery.of(context).size.width,
            //     fit: BoxFit.cover),
            // Container(
            //   child: const Text(""),
            //   color: Colors.grey,
            //   height: MediaQuery.of(context).size.height * 0.02,
            // ),
            Image.asset("images/img_logos.png",
                height: 120, width: 120, fit: BoxFit.cover),
            const SizedBox(height: 15.0),
            Container(
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFFFFD966),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("LỰA CHỌN ĐỐI TƯỢNG NHẬP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFC22026),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("THÔNG TIN - DỮ LIỆU",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFC22026),
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "HỘ DÂN",
              onClickAction: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CivilView(
                              edit: "-1",
                              onRefresh: (result) {},
                            )))
              },
              obj: {
                'borderColor': Colors.blue,
                'borderWidth': 2.0,
                'titleColor': Colors.black,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 17.0
              },
            ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "NHÀ VĂN HÓA",
              onClickAction: () =>
                  {_showToast('Chức năng hiện trong quá trình nâng cấp')},
              obj: {
                'borderColor': Colors.blue,
                'titleColor': Colors.black,
                'borderWidth': 2.0,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 17.0
              },
            ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "TRƯỜNG HỌC",
              onClickAction: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SchoolView(edit: "-1", onRefresh: (result) {})))
              },
              obj: {
                'borderColor': Colors.blue,
                'borderWidth': 2.0,
                'titleColor': Colors.black,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 17.0
              },
            ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "ỦY BAN NHÂN DÂN",
              onClickAction: () =>
                  {_showToast('Chức năng hiện trong quá trình nâng cấp')},
              obj: {
                'borderColor': Colors.blue,
                'titleColor': Colors.black,
                'borderWidth': 2.0,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 17.0
              },
            ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "BỆNH VIỆN",
              onClickAction: () =>
                  {_showToast('Chức năng hiện trong quá trình nâng cấp')},
              obj: {
                'borderColor': Colors.blue,
                'titleColor': Colors.black,
                'borderWidth': 2.0,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 17.0
              },
            ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "DANH SÁCH",
              onClickAction: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Listing(title: 'Danh sách')))
              },
              obj: {
                'borderColor': Colors.blue,
                'borderWidth': 2.0,
                'titleColor': Colors.black,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 17.0
              },
            ),
            const SizedBox(height: 25.0),
          ],
        ));
  }

  _showToast(mess) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mess)))
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    Storing().initCounter();
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 9,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(), child: body())),
      ],
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './result.dart';
import './test.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class LoginView extends StatelessWidget {
  final String vrpOption;
  const LoginView({Key? key, required this.vrpOption}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Thông tin xác thực"),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
          child: Center(
        child: MyHomePage(option: vrpOption),
      )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String option;
  const MyHomePage({Key? key, required this.option}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String id = "";

  String name = "";

  String birthDay = "";

  String address = "";

  String errorMessage = "";

  String vrpResult = "";

  bool showResult = false;

  static final TextEditingController _textController = TextEditingController();

  static const channel = MethodChannel('vmg.ekyc/VRP');

  Future<void> _callForVRP(option) async {
    try {
      await channel.invokeMethod(
          'VRP', <String, String>{'option': option}).then((onValue) {
        if (onValue != "") {
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const TestView(title: 'ndd')));
          setState(() {
            vrpResult = onValue;
            showResult = true;
          });
        } else {
          setState(() {
            showResult = true;
          });
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => const TestView(title: 'ndd')));
        }
      });
    } on PlatformException catch (e) {
      print('Failed : ${e.message}');
      setState(() {
        errorMessage = e.message!;
      });
    }
  }

  Future<dynamic> didRequestLogin(message) async {
    Map<String, dynamic> body = {"message": message};
    http.Response response = await http.post(
      Uri.parse("https://webhook.site/5cda9725-8273-434b-bf34-b68c9891ae87"),
      body: body,
      headers: {"Accept": "application/json"},
      encoding: Encoding.getByName('utf-8'),
    );

    Map<String, dynamic> dataToken = jsonDecode(response.body);
  }

  Widget emailField() {
    return TextField(
      obscureText: false,
      onChanged: (text) {
        setState(() {
          id = text;
          errorMessage = "";
        });
      },
      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Số CMT/ CCCD",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
  }

  Widget passwordField() {
    return TextField(
      obscureText: false,
      onChanged: (text) {
        setState(() {
          name = text;
          errorMessage = "";
        });
      },
      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Họ và tên",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
  }

  Widget birthDayField() {
    return TextField(
      obscureText: false,
      onChanged: (text) {
        setState(() {
          birthDay = text;
          errorMessage = "";
        });
      },
      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Ngày tháng năm sinh",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
  }

  Widget addressField() {
    return TextField(
      obscureText: false,
      onChanged: (text) {
        setState(() {
          address = text;
          errorMessage = "";
        });
      },
      style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15.0),
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Địa chỉ",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
    );
  }

  Container buttoning({required Function onClickAction}) {
    return Container(
        child: Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width - 120,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          onClickAction();
        },
        child: const Text("Xác thực thông tin",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Montserrat', color: Colors.white, fontSize: 18.0)),
      ),
    ));
  }

  Container empty() {
    return Container(
        child: Column(
      children: [
        const Text('Không có thông tin xác thực',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 35.0),
        Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: const Color(0xff01A0C7),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width - 120,
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              setState(() {
                showResult = false;
              });
            },
            child: const Text("Xác thực lại thông tin",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 18.0)),
          ),
        )
      ],
    ));
  }

  void _didRequest(option) {
    if (id.isEmpty || name.isEmpty || address.isEmpty || birthDay.isEmpty) {
      setState(() {
        errorMessage = "Bạn cần nhập đủ thông tin xác thực";
      });
      return;
    }
    _callForVRP(option);
  }

  Widget body() {
    return Padding(
        padding: EdgeInsets.all(showResult ? 0.0 : 16),
        child: showResult
            ? vrpResult == ""
                ? empty()
                : ResultView(
                    data: vrpResult,
                    id: id,
                    name: name,
                    birthDay: birthDay,
                    address: address)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: const Text(""),
                    color: Colors.grey,
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Nhập thông tin của CMT/ Thẻ căn cước",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                  const SizedBox(height: 35.0),
                  emailField(),
                  const SizedBox(height: 35.0),
                  passwordField(),
                  const SizedBox(height: 35.0),
                  birthDayField(),
                  const SizedBox(height: 35.0),
                  addressField(),
                  const SizedBox(height: 15.0),
                  Text(errorMessage,
                      style: const TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      )),
                  const SizedBox(height: 25.0),
                  buttoning(onClickAction: () => _didRequest(widget.option))
                ],
              ));
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _textController.text = "";
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
    return body();
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import './util/storage.dart';
import 'dart:io';
import 'option.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    // color: Colors.pink,
                    image: DecorationImage(
                      image: AssetImage("images/img_bg_bg.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Center(
                  child: Center(child: MyHomePage()),
                )
              ],
            )));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String name = "";

  String password = "";

  String errorMessage = "";

  bool isLogin = false;

  bool _isObscure = true;

  static final TextEditingController _textController = TextEditingController();

  Future<dynamic> didRequestLogin(message) async {
    var url = message.runtimeType == String
        ? "http://gisgo.vn:8016/api/auth/login?username=${name}&password=${password}"
        : "http://gisgo.vn:8016/api/auth/login?username=${message['name']}&password=${message['password']}";
    http.Response response = await http.get(
      Uri.parse(url),
      headers: {"Accept": "application/json"},
    );

    context.loaderOverlay.hide();
    Map<String, dynamic> data = jsonDecode(response.body);

    if (data['status'] == "OK") {
      if (isLogin) {
        Storing().addString(
            message.runtimeType == String ? name : message['name'], 'name');
        Storing().addString(
            message.runtimeType == String ? password : message['password'],
            'password');
      } else {
        Storing().delString('name');
        Storing().delString('password');
      }
      Storing().addString(data['data']['token'], 'token');
      Route route = MaterialPageRoute(builder: (context) => const OptionView());
      Navigator.pushReplacement(context, route);
    } else {
      var error = data['errors'][0];
      _showToast(error['message']);
    }
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  _showToast(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mess),
    ));
  }

  Widget emailField() {
    return TextField(
      obscureText: false,
      onChanged: (text) {
        setState(() {
          name = text;
          errorMessage = "";
        });
      },
      style: const TextStyle(
          fontFamily: 'Montserrat', fontSize: 17.0, color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.5),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Tên đăng nhập",
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextField(
        obscureText: _isObscure,
        onChanged: (text) {
          setState(() {
            password = text;
            errorMessage = "";
          });
        },
        style: const TextStyle(
            fontFamily: 'Montserrat', fontSize: 17.0, color: Colors.white),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(
              _isObscure ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.5),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Mật khẩu",
          hintStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ));
  }

  Widget forgot() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              side: MaterialStateBorderSide.resolveWith(
                (states) => const BorderSide(width: 1.5, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              checkColor: Colors.white,
              activeColor: Colors.blueAccent,
              value: isLogin,
              onChanged: (bool? value) {
                setState(() {
                  isLogin = value!;
                });
                Storing().addString(value == true ? "1" : "0", "logged");
              },
            )),
        const SizedBox(
          width: 5,
        ),
        const Text(
          "Lưu mật khẩu",
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
      ]),
      DecoratedBox(
        decoration: const BoxDecoration(color: null),
        child: GestureDetector(
          onTap: () {},
          child: const Text(
            "Quên mật khẩu?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget buttoning({required Function onClickAction}) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(39, 77, 158, 1),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width - 0,
            padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () {
              onClickAction();
            },
            child: const Text(
              "Đăng nhập",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ));
  }

  void _didRequestLogin() async {
    if (!await hasNetwork()) {
      _showToast('Mạng internet không khả dụng');
      return;
    }
    if (password.isEmpty || name.isEmpty) {
      setState(() {
        errorMessage = "Bạn cần nhập đủ thông tin đăng nhập";
      });
      return;
    }
    context.loaderOverlay.show();

    didRequestLogin('');
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(""),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Image.asset("images/img_logos.png",
                height: 120, width: 120, fit: BoxFit.cover),
            const SizedBox(height: 15.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("CÔNG CỤ THU THẬP DỮ LIỆU",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    )),
                Text("PHỤC VỤ PHÒNG CHỐNG THIÊN TAI",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            const SizedBox(height: 25.0),
            emailField(),
            const SizedBox(height: 35.0),
            passwordField(),
            const SizedBox(height: 15.0),
            forgot(),
            const SizedBox(height: 5.0),
            Text(errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                )),
            const SizedBox(height: 15.0),
            buttoning(
                onClickAction: () => {
                      _didRequestLogin(),
                      FocusScope.of(context).requestFocus(FocusNode())
                    })
          ],
        ));
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _textController.text = "";
    Storing().initCounter();
    initData();
  }

  initData() async {
    if (await Storing().getString('logged') == "" ||
        await Storing().getString('logged') == null) {
      Storing().addString("0", 'logged');
    }
    String bo = await Storing().getString('logged');
    setState(() {
      isLogin = bo == "1";
    });
    // String token = await Storing().getString('token');
    if (bo == "1") {
      if (!await hasNetwork()) {
        Route route =
            MaterialPageRoute(builder: (context) => const OptionView());
        Navigator.pushReplacement(context, route);
      } else {
        String name = await Storing().getString('name');
        String password = await Storing().getString('password');
        context.loaderOverlay.show();
        setState(() {
          name = name;
          password = password;
          didRequestLogin({'name': name, 'password': password});
        });
      }
    }
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
        Container(
            alignment: Alignment.center,
            height: 60,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: const Divider(
                      color: Colors.white,
                    )),
                const Text(
                    'Công cụ được quản lý bởi bản chỉ đạo quốc gia về \n PCTT và hỗ trợ UNDP, Green Climate Fund',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.normal))
              ],
            )),
      ],
    );
  }
}

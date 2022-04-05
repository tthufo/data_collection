import 'dart:async';
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
                    color: Colors.pink,
                    // image: DecorationImage(
                    //   image: AssetImage("images/bg_img.png"),
                    //   fit: BoxFit.cover,
                    // ),
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

  static final TextEditingController _textController = TextEditingController();

  Future<dynamic> didRequestLogin(message) async {
    // Map<String, dynamic> body = {"message": message};

    http.Response response = await http.get(
      Uri.parse(
          "https://thiethai.vggisopen.com/api/auth/login?username=sa&password=123456"),
      // body: body,
      headers: {"Accept": "application/json"},
      // encoding: Encoding.getByName('utf-8'),
    );

    // Map<String, dynamic> dataToken = jsonDecode(response.body);
    print(response.body);
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
        obscureText: true,
        onChanged: (text) {
          setState(() {
            password = text;
            errorMessage = "";
          });
        },
        style: const TextStyle(
            fontFamily: 'Montserrat', fontSize: 17.0, color: Colors.white),
        decoration: InputDecoration(
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

  Container forgot() {
    return Container(
      height: 30,
      alignment: Alignment.centerRight,
      child: DecoratedBox(
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
    );
  }

  Container buttoning({required Function onClickAction}) {
    return Container(
        child: Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.greenAccent,
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OptionView()));

    if (!await hasNetwork()) {
      _showToast('Mạng internet không khả dụng');
      return;
    }
    // context.loaderOverlay.show();

    didRequestLogin('');

    if (password.isEmpty || name.isEmpty) {
      setState(() {
        errorMessage = "Bạn cần nhập đủ thông tin xác thực";
      });
      return;
    }
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
            forgot(),
            const SizedBox(height: 5.0),
            Text(errorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                )),
            const SizedBox(height: 15.0),
            buttoning(onClickAction: () => {_didRequestLogin()})
          ],
        ));
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    _textController.text = "";
    Storing().initCounter();
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
                    child: const Divider(color: Colors.grey)),
                const Text(
                    'Công cụ được quản lý bởi bản chỉ đạo quốc gia về \n PCTT và hỗ trợ UNDP, Green Climate Fund',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontStyle: FontStyle.italic))
              ],
            )),
      ],
    );
  }
}

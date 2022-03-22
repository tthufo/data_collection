import 'package:flutter/material.dart';
import './login.dart';

class OptionView extends StatelessWidget {
  final String title;

  const OptionView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: true,
      ),
      body: const Center(
        child: Option(),
      ),
    );
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option> with WidgetsBindingObserver {
  goToLogin(String opt) {
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context) => LoginView(vrpOption: opt)));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  Container optioning(String title, {required Function onClickAction}) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xff01A0C7),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(5.0),
                onPressed: () {
                  onClickAction();
                },
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 15.0)),
              ),
            )));
  }

  Container buttoning(String title, {required Function onClickAction}) {
    return Container(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width - 60,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  onClickAction();
                },
                child: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.lightBlueAccent,
                        fontSize: 14.0)),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
          child: Container(
              child: Row(children: <Widget>[
            Spacer(),
          ])),
          flex: 1),
      Material(child: Center()),
      Expanded(
          child: Center(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("VMG eKYC",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.lightBlueAccent,
                        fontSize: 30.0)),
                const SizedBox(height: 20),
                buttoning(
                  "1. Phiên bản tiêu chuẩn \n+ Xác thực một góc độ khuôn mặt \n+ Xác thực mặt trước giấy tờ",
                  onClickAction: () {
                    goToLogin("0");
                  },
                ),
                buttoning(
                    "2. Phiên bản nâng cao 1 \n+ Xác thực hai góc độ khuôn mặt \n+ Xác thực mặt trước giấy tờ",
                    onClickAction: () {
                  goToLogin("1");
                }),
                buttoning(
                  "3. Phiên bản nâng cao 2 \n+ Xác thực ba góc độ khuôn mặt \n+ Xác thực mặt trước giấy tờ",
                  onClickAction: () {
                    goToLogin("2");
                  },
                ),
                buttoning(
                  "4. Phiên bản nâng cao 3 \n+ Xác thực bốn góc độ khuôn mặt \n+ Xác thực mặt trước giấy tờ",
                  onClickAction: () {
                    goToLogin("3");
                  },
                ),
              ],
            ),
          )),
          flex: 100),
    ]);
  }
}

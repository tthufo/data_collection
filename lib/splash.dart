// ignore_for_file: deprecated_member_use
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import './options.dart';

class SplashView extends StatelessWidget {
  final String title;
  const SplashView({Key? key, required this.title}) : super(key: key);

  static const channel = MethodChannel('vmg.ekyc/VRP');

  Future<void> _callForVRP(option) async {
    final String vrpData =
        await channel.invokeMethod('VRP', <String, String>{'option': option});
    Future.delayed(const Duration(milliseconds: 600), () {
      print(vrpData);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => ResultView(
      //             data: vrpData,
      //             id: id,
      //             name: name,
      //             birthDay: birthDay,
      //             address: address)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(children: [
          const Spacer(),
          const Text("EKYC VMG",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
          Image.asset(
            "images/ic_register.png",
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.width - 50,
          ),
          FlatButton(
            onPressed: () {
              // _callForVRP("0");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OptionView(title: "Lựa chọn phiên bản")));
            },
            child: const Text("Bắt đầu",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 20.0)),
            color: Colors.lightBlueAccent,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Colors.blue, width: 0, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(50)),
          ),
          const Spacer(),
        ]),
      ),
    );
  }

  Container buttoning(String title, {required Function onClickAction}) {
    return Container(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Material(
              elevation: 2.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Colors.blue,
              child: MaterialButton(
                minWidth: 100,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () {
                  onClickAction();
                },
                child: Text(title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 20.0)),
              ),
            )));
  }
}

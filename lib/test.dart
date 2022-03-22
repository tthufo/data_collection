// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';

class TestView extends StatelessWidget {
  final String title;
  const TestView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Column(children: [
          const Spacer(),
          const Text("Test screen",
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
          Image.asset(
            "images/Ava.png",
            width: MediaQuery.of(context).size.width - 50,
            height: MediaQuery.of(context).size.width - 50,
          ),
          FlatButton(
            onPressed: () {
              // _callForVRP("0");
            },
            child: const Text("Test screen",
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

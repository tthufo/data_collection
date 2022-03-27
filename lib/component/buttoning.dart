import 'package:flutter/material.dart';

class Buttoning extends StatelessWidget {
  final String title;
  final Function() onClickAction;
  final Map<String, dynamic> obj;

  const Buttoning(
      {Key? key,
      required this.title,
      required this.onClickAction,
      required this.obj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttoning(title, onClickAction: onClickAction);
  }

  Container buttoning(String title, {required Function onClickAction}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: obj['borderColor'] ?? Colors.transparent),
            borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            color: obj['bgColor'] ?? Colors.white,
            child: SizedBox(
              width: obj['width'] ?? 100,
              height: obj['height'] ?? 35,
              child: MaterialButton(
                minWidth: 60,
                height: 40,
                onPressed: () {
                  onClickAction();
                },
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: obj['titleColor'] ?? Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )));
  }
}

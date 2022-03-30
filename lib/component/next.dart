import 'package:flutter/material.dart';

class Next extends StatelessWidget {
  final Function() onClickAction;

  const Next({
    Key? key,
    required this.onClickAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(children: [
          buttoning(onClickAction: onClickAction),
          const SizedBox(
            height: 5,
          ),
          const Text('(Bổ sung thông tin người tiếp theo trong hộ)',
              style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey))
        ]));
  }

  Container buttoning({required Function onClickAction}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(0.0)),
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(0.0),
            color: Colors.white,
            child: SizedBox(
              width: 150,
              height: 35,
              child: MaterialButton(
                minWidth: 60,
                height: 40,
                onPressed: () {
                  onClickAction();
                },
                child: const Text(
                  'Người tiếp theo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
              ),
            )));
  }
}

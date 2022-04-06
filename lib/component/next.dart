import 'package:flutter/material.dart';
import '../component/buttoning.dart';

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
          Buttoning(
            title: "Người tiếp theo",
            onClickAction: onClickAction,
            obj: const {
              'borderColor': Colors.blue,
              'titleColor': Colors.black,
              'width': 150.0,
              'height': 40.0,
              'fontSize': 15.0
            },
          ),
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
}

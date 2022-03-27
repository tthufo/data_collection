import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class CameraView extends StatelessWidget {
  final Function(String) onClickAction;

  const CameraView({
    Key? key,
    required this.onClickAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return camview(context);
  }

  Widget roundedRectBorderWidget(BuildContext context) {
    return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        color: Colors.greenAccent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container(
            height: (MediaQuery.of(context).size.width / 1.5) * 0.65,
            width: (MediaQuery.of(context).size.width / 1.5),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                  onTap: () {
                    onClickAction('1');
                  },
                  child: Image.asset(
                    "images/camera.png",
                    height: (MediaQuery.of(context).size.width / 1.5) / 3,
                    width: (MediaQuery.of(context).size.width / 1.5) / 2.5,
                    fit: BoxFit.fill,
                  )),
              const SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    onClickAction('2');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'hoặc',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'upload file',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline),
                      )
                    ],
                  ))
            ]),
          ),
        ));
  }

  Center camview(BuildContext context) {
    return Center(
        child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: roundedRectBorderWidget(context)));
  }
}

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class CameraView extends StatelessWidget {
  final String title;
  final Function(String) onClickAction;

  const CameraView({
    Key? key,
    required this.onClickAction,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return caming();
  }

  Widget caming() {
    return Column(
      children: [
        const Divider(
          color: Colors.black,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              const Text('(Thực hiện sau khi đã xong thông tin trên)',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () {
                  onClickAction('2');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Tải file ảnh',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '(tên ảnh)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                )),
            GestureDetector(
                onTap: () {
                  onClickAction('1');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Chụp ảnh',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '(tên ảnh)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ))
          ],
        )
      ],
    );
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

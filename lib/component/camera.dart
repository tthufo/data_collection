import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CameraView extends StatefulWidget {
  final String title;
  final Map<String, dynamic> obj;
  final Function(String) onClickAction;

  const CameraView({
    Key? key,
    required this.onClickAction,
    required this.title,
    required this.obj,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CameraView> {
  String picture = "";

  @override
  initState() {
    super.initState();
    setState(() {
      picture = widget.obj["picture"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return camview(context); // caming();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obj["picture"] != widget.obj["picture"]) {
      if (widget.obj["picture"] != "") {
        _getPic();
      } else {
        setState(() {
          picture = "";
        });
      }
    }
  }

  _getPic() async {
    var localPath = await _localPath;
    setState(() {
      picture = "$localPath/${widget.obj["picture"]}";
    });
  }

  Widget caming() {
    return Column(
      children: [
        const Divider(
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
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
                  widget.onClickAction('2');
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
                  widget.onClickAction('1');
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
        ),
        const SizedBox(height: 20)
      ],
    );
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Widget roundedRectBorderWidget(BuildContext context) {
    return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        color: Colors.blueAccent,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: SizedBox(
            height: (MediaQuery.of(context).size.width / 1.5) * 0.65,
            width: (MediaQuery.of(context).size.width / 1.5),
            child: picture != ''
                ? Image.file(File(picture))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        GestureDetector(
                            onTap: () {
                              widget.onClickAction('1');
                            },
                            child: Image.asset(
                              "images/camera.png",
                              height:
                                  (MediaQuery.of(context).size.width / 1.5) / 3,
                              width: (MediaQuery.of(context).size.width / 1.5) /
                                  2.5,
                              fit: BoxFit.fill,
                            )),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () {
                              widget.onClickAction('2');
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

  Widget camview(BuildContext context) {
    return Column(children: [
      const Divider(
        color: Colors.grey,
        // height: 1,
      ),
      Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title,
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
      Center(
          child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(children: [
                const SizedBox(height: 10),
                roundedRectBorderWidget(context),
                picture != ""
                    ? GestureDetector(
                        onTap: () {
                          widget.onClickAction('3');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 10),
                            Text(
                              'Chụp lại',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(height: 5),
                          ],
                        ))
                    : const SizedBox(height: 10)
              ]))),
      const SizedBox(height: 10),
    ]);
  }
}

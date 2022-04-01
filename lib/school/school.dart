import 'package:flutter/material.dart';
import 'package:vrp_app/component/checker.dart';
import 'package:vrp_app/component/header.dart';
import 'dart:async';
import 'dart:io';
import '../component/buttoning.dart';
import '../component/coordinate.dart';
import '../component/camera.dart';
import '../component/input.dart';
import '../component/textfield.dart';
import '../util/storage.dart';

import 'package:image_picker/image_picker.dart';

class SchoolView extends StatelessWidget {
  const SchoolView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // set it to false
        appBar: AppBar(
          title: const Text("Trường học"),
          automaticallyImplyLeading: true,
        ),
        body: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Map<String, dynamic> latLong = {
    'lat': '-',
    'long': '-',
  };

  Map<String, dynamic> level_1 = {
    'room': '',
    'pupil': '',
    'femaleNo': '',
  };

  late File _image;

  final picker = ImagePicker();

  Future getCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = image as File;
    });
  }

  Future getGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image as File;
    });
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Heading(obj: {
              'start': 'THÔNG TIN CHUNG',
              'mid': 'Mã số TH:',
              'end': '001'
            }),
            CoordinateView(
                latLong: latLong,
                onChange: (coordinate) => {
                      setState(() {
                        latLong = coordinate;
                      })
                    }),
            level(),
            school(),
            condition(),
            const Heading(obj: {
              'title': 'THÔNG TIN CHI TIẾT',
            }),
            detail(),
            CameraView(
              title: 'Ảnh trường học',
              onClickAction: (typing) {
                if (typing == "1") {
                  getCamera();
                } else {
                  getGallery();
                }
              },
            ),
          ],
        ));
  }

  Map<String, dynamic> gradeObj = {
    'lvl1': '0',
    'lvl2': '0',
    'lvl3': '0',
    'lvl4': '0',
    'lvl5': '0',
    'lvl6': '0',
    'lvl7': '0',
  };

  _resetGrade(typing) {
    setState(() {
      if (gradeObj[typing] == "0") {
        for (var v in gradeObj.keys) {
          gradeObj[v] = "0";
        }
        gradeObj[typing] = "1";
      } else {
        for (var v in gradeObj.keys) {
          gradeObj[v] = "0";
        }
      }
    });
  }

  Widget level() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Cấp:"),
                const SizedBox(width: 5),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl1");
                    },
                    obj: {"title": "M.Giáo", "checked": gradeObj["lvl1"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl2");
                    },
                    obj: {"title": "Tiểu \nhọc", "checked": gradeObj["lvl2"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl3");
                    },
                    obj: {"title": "PTCS", "checked": gradeObj["lvl3"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl4");
                    },
                    obj: {"title": "PTTH", "checked": gradeObj["lvl4"]})
              ],
            ),
            Row(
              children: [
                const Text(
                  "Cấp:",
                  style: TextStyle(color: Colors.transparent),
                ),
                const SizedBox(width: 5),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl5");
                    },
                    obj: {"title": "Đại học", "checked": gradeObj["lvl5"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl6");
                    },
                    obj: {"title": "Cao đẳng", "checked": gradeObj["lvl6"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl7");
                    },
                    obj: {"title": "Dạy nghề", "checked": gradeObj["lvl7"]}),
              ],
            )
          ],
        ));
  }

  Widget school() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: const [
                Text("Tên trường:"),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 40),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: InputView(
                        obj: const {"hintText": ""},
                        onChange: (selectedItem) {
                          setState(() {
                            // obj = selectedItem;
                          });
                        })),
              ],
            )
          ],
        ));
  }

  Widget condition() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Row(
              children: const [
                Text("T.Trạng nhà:"),
              ],
            ),
            Row(
              children: [
                const Text(
                  "Cấp:",
                  style: TextStyle(color: Colors.transparent),
                ),
                const SizedBox(width: 5),
                Checker(onChange: (typing) {}, obj: {"title": "Nh.kiên cố"}),
                Checker(
                    onChange: (typing) {}, obj: {"title": "Nh.bán \nkiên cố"}),
                Checker(onChange: (typing) {}, obj: {"title": "Nh.đơn sơ"}),
              ],
            )
          ],
        ));
  }

  Widget detail() {
    return Column(children: [
      Row(children: [
        FieldView(
            obj: {
              "start": "Số phòng học:",
              "text": level_1['room'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {
                level_1['room'] = texting;
              });
            })
      ]),
      Row(children: [
        FieldView(
            obj: {
              "start": "Số học sinh:   ",
              "end": "người",
              "text": level_1['pupil'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {
                level_1['pupil'] = texting;
              });
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FieldView(
            obj: {
              "width": 60.0,
              "pre": "Trong đó:",
              "start": "Nam",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            }),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Nữ",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            })
      ]),
      Row(children: [
        FieldView(
            obj: {
              "start": "Số GV/C.bộ:   ",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FieldView(
            obj: {
              "width": 60.0,
              "pre": "Trong đó:",
              "start": "Nam",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            }),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Nữ",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
        Text('Số người có thể sơ tán phòng chống thiên tai:')
      ]),
      Row(children: [
        FieldView(
            obj: {
              "start": "Tổng số:         ",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FieldView(
            obj: {
              "width": 60.0,
              "pre": "Trong đó:",
              "start": "Nam",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            }),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Nữ",
              "end": "người",
              "text": "",
              "type": TextInputType.number,
            },
            onChange: (texting) {
              setState(() {});
            })
      ]),
    ]);
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
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

  Widget footer() {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Colors.black,
        ),
        Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Buttoning(
                  title: "Xóa",
                  onClickAction: () => {},
                  obj: const {
                    'width': 60.0,
                  },
                ),
                Buttoning(
                  title: "H.Thành/Lưu",
                  onClickAction: () => {print(gradeObj)},
                  obj: const {
                    'width': 120.0,
                  },
                ),
                GestureDetector(
                    onTap: () {
                      // print(single().task);
                    },
                    child: Image.asset(
                      "images/img_home.png",
                      height: 40,
                      width: 40,
                      fit: BoxFit.fill,
                    ))
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 9,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(), child: body())),
        footer(),
      ],
    );
  }
}

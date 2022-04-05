import 'package:flutter/material.dart';
import 'package:vrp_app/component/checker.dart';
import 'package:vrp_app/component/header.dart';
import 'dart:async';
import 'dart:io';

import '../component/buttoning.dart';
import '../component/coordinate.dart';
import '../component/camera.dart';
import '../component/textfield.dart';
import '../util/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

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
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: const MyHomePage()));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String unitNo = "";

  Map<String, dynamic> latLong = {
    'lat': '',
    'long': '',
    'checked': false,
    'valid': false,
  };

  Map<String, dynamic> gradeObj = {
    'lvl1': '0',
    'lvl2': '0',
    'lvl3': '0',
    'lvl4': '0',
    'lvl5': '0',
    'lvl6': '0',
    'lvl7': '0',
    'school': '',
    'con1': '0',
    'con2': '0',
    'con3': '0',
    'valid': false,
  };

  Map<String, dynamic> schoolDetail = {
    'room': '',
    'pupil': '',
    'pupilMale': '',
    'pupilFemale': '',
    'teacher': '',
    'teacherMale': '',
    'teacherFemale': '',
    'peopleEvac': '',
    'peopleEvacMale': '',
    'peopleEvacFemale': '',
    'schoolPicture': '',
    'valid': false,
  };

  var gradeKey = [
    "lvl1",
    "lvl2",
    "lvl3",
    "lvl4",
    "lvl5",
    "lvl6",
    "lvl7",
  ];

  var conditionKey = ["con1", "con2", "con3"];

  List<dynamic> listText = <dynamic>[];

  late XFile _image;

  Map<String, dynamic> validOther = {
    'checkPicture': false,
  };

  Map<String, dynamic> _mergeAll() {
    return {
      "coordinate": latLong,
      "grade": gradeObj,
      "detail": schoolDetail,
    };
  }

  bool validate() {
    if (latLong['lat'] == "" || latLong['long'] == "") {
      setState(() {
        latLong['valid'] = true;
      });
      return false;
    }

    if (_validHeader) {
      setState(() {
        gradeObj['valid'] = true;
      });
      return false;
    }

    if (_validDetail) {
      setState(() {
        schoolDetail['valid'] = true;
      });
      return false;
    }

    if (schoolDetail['schoolPicture'] == "") {
      setState(() {
        validOther['checkPicture'] = true;
      });
      return false;
    }

    return true;
  }

  void getCounter() async {
    int? counter = await Storing().getCounter('schoolIndex');
    setState(() {
      unitNo = counter.toString();
    });
  }

  Future getCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return;
    }
    var path = await _localPath;
    var fileName = image.name;
    await image.saveTo('$path/$fileName');
    setState(() {
      _image = image;
      schoolDetail['schoolPicture'] = image.name;
      validOther['checkPicture'] = false;
    });
  }

  Future getGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }
    var path = await _localPath;
    var fileName = image.name;
    await image.saveTo('$path/$fileName');
    setState(() {
      _image = image;
      schoolDetail['schoolPicture'] = image.name;
      validOther['checkPicture'] = false;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  bool get _validCoor {
    return latLong['lat'] == "" || latLong['long'] == "";
  }

  bool get _validHeader {
    var gradeList = gradeKey.where((item) {
      return gradeObj[item] == "1";
    });
    var conditionList = conditionKey.where((item) {
      return gradeObj[item] == "1";
    });
    return gradeList.isEmpty ||
        conditionList.isEmpty ||
        gradeObj['school'] == '';
  }

  bool get _validDetail {
    for (var key in schoolDetail.keys) {
      if (schoolDetail[key] == "" && key != "schoolPicture" && key != "valid") {
        return true;
      }
    }
    return false;
  }

  _resetAll() {
    setState(() {
      latLong = {
        'lat': '',
        'long': '',
        'checked': false,
        'valid': false,
      };

      schoolDetail = {
        'room': '',
        'pupil': '',
        'pupilMale': '',
        'pupilFemale': '',
        'teacher': '',
        'teacherMale': '',
        'teacherFemale': '',
        'peopleEvac': '',
        'peopleEvacMale': '',
        'peopleEvacFemale': '',
        'schoolPicture': '',
        'valid': false,
      };

      gradeObj = {
        'lvl1': '0',
        'lvl2': '0',
        'lvl3': '0',
        'lvl4': '0',
        'lvl5': '0',
        'lvl6': '0',
        'lvl7': '0',
        'school': '',
        'con1': '0',
        'con2': '0',
        'con3': '0',
        'valid': false,
      };
    });

    for (TextEditingController text in listText) {
      text.clear();
    }
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Heading(obj: {
              'start': 'THÔNG TIN CHUNG',
              'mid': 'Mã số TH:',
              'end': unitNo
            }),
            CoordinateView(
                latLong: latLong,
                onChange: (coordinate) => {
                      setState(() {
                        latLong = coordinate;
                      })
                    }),
            AbsorbPointer(
                absorbing: _validCoor,
                child: Container(
                    decoration: BoxDecoration(
                        color: _validCoor
                            ? const Color.fromARGB(20, 156, 156, 156)
                            : Colors.transparent,
                        border: Border.all(
                            width: 2,
                            color: gradeObj['valid'] == false
                                ? Colors.transparent
                                : Colors.redAccent)),
                    child: Column(children: [
                      level(),
                      school(),
                      condition(),
                    ]))),
            const Heading(obj: {
              'title': 'THÔNG TIN CHI TIẾT',
            }),
            AbsorbPointer(
                absorbing: _validCoor || _validHeader,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: !schoolDetail['valid']
                            ? Colors.transparent
                            : Colors.redAccent,
                      ),
                      color: _validCoor
                          ? const Color.fromARGB(20, 156, 156, 156)
                          : Colors.transparent,
                    ),
                    child: detail())),
            AbsorbPointer(
                absorbing: _validCoor || _validHeader || _validDetail,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: !validOther['checkPicture']
                              ? Colors.transparent
                              : Colors.redAccent),
                      color: _validCoor
                          ? const Color.fromARGB(20, 156, 156, 156)
                          : Colors.transparent,
                    ),
                    child: CameraView(
                      title: 'Ảnh trường học',
                      obj: {"picture": schoolDetail['schoolPicture']},
                      onClickAction: (typing) {
                        if (typing == "1") {
                          getCamera();
                        } else if (typing == "2") {
                          getGallery();
                        } else {
                          setState(() {
                            schoolDetail['schoolPicture'] = "";
                            validOther['checkPicture'] = false;
                          });
                        }
                      },
                    ))),
          ],
        ));
  }

  _resetGrade(typing, isGrade) {
    var array = isGrade ? gradeKey : conditionKey;
    setState(() {
      if (gradeObj[typing] == "0") {
        for (var v in gradeObj.keys) {
          if (array.contains(v)) {
            gradeObj[v] = "0";
          }
        }
        gradeObj[typing] = "1";
      } else {
        for (var v in gradeObj.keys) {
          if (array.contains(v)) {
            gradeObj[v] = "0";
          }
        }
      }
      gradeObj['valid'] = false;
    });
  }

  Widget level() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Cấp:"),
                const SizedBox(width: 5),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl1", true);
                    },
                    obj: {"title": "M.Giáo", "checked": gradeObj["lvl1"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl2", true);
                    },
                    obj: {"title": "Tiểu \nhọc", "checked": gradeObj["lvl2"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl3", true);
                    },
                    obj: {"title": "PTCS", "checked": gradeObj["lvl3"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl4", true);
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
                      _resetGrade("lvl5", true);
                    },
                    obj: {"title": "Đại học", "checked": gradeObj["lvl5"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl6", true);
                    },
                    obj: {"title": "Cao đẳng", "checked": gradeObj["lvl6"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("lvl7", true);
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
                const SizedBox(width: 20),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: FieldView(
                        obj: {
                          "limit": 100,
                          "width": MediaQuery.of(context).size.width * 0.6,
                        },
                        onChange: (texting) {
                          if (texting.runtimeType != String) {
                            listText.add(texting);
                          } else {
                            setState(() {
                              gradeObj['school'] = texting;
                              gradeObj['valid'] = false;
                            });
                          }
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
                Checker(
                    onChange: (typing) {
                      _resetGrade("con1", false);
                    },
                    obj: {"title": "Nh.kiên cố", "checked": gradeObj["con1"]}),
                Checker(
                    onChange: (typing) {
                      _resetGrade("con2", false);
                    },
                    obj: {
                      "title": "Nh.bán \nkiên cố",
                      "checked": gradeObj["con2"]
                    }),
                Checker(
                    onChange: (typing) {
                      _resetGrade("con3", false);
                    },
                    obj: {"title": "Nh.đơn sơ", "checked": gradeObj["con3"]}),
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
              "text": schoolDetail['room'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['room'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
      Row(children: [
        FieldView(
            obj: {
              "start": "Số học sinh:   ",
              "end": "người",
              "text": schoolDetail['pupil'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['pupil'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FieldView(
            obj: {
              "width": 60.0,
              "pre": "Trong đó:",
              "start": "Nam",
              "end": "người",
              "text": schoolDetail['pupilMale'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['pupilMale'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            }),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Nữ",
              "end": "người",
              "text": schoolDetail['pupilFemale'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['pupilFemale'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
      Row(children: [
        FieldView(
            obj: {
              "start": "Số GV/C.bộ:   ",
              "end": "người",
              "text": schoolDetail['teacher'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['teacher'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FieldView(
            obj: {
              "width": 60.0,
              "pre": "Trong đó:",
              "start": "Nam",
              "end": "người",
              "text": schoolDetail['teacherMale'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['teacherMale'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            }),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Nữ",
              "end": "người",
              "text": schoolDetail['teacherFemale'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['teacherFemale'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
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
              "text": schoolDetail['peopleEvac'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['peopleEvac'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        FieldView(
            obj: {
              "width": 60.0,
              "pre": "Trong đó:",
              "start": "Nam",
              "end": "người",
              "text": schoolDetail['peopleEvacMale'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['peopleEvacMale'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            }),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Nữ",
              "end": "người",
              "text": schoolDetail['peopleEvacFemale'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add(texting);
              } else {
                setState(() {
                  schoolDetail['peopleEvacFemale'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
    ]);
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
    getCounter();
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

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  _showToast(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mess),
    ));
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
                  onClickAction: () => {_resetAll()},
                  obj: const {
                    'width': 60.0,
                  },
                ),
                Buttoning(
                  title: "H.Thành/Lưu",
                  onClickAction: () async => {
                    if (validate())
                      {
                        if (await hasNetwork())
                          {}
                        else
                          {
                            Storing().addData(
                                {'id': unitNo, 'data': _mergeAll()}, 'school'),
                            await Storing().updateCounter('schoolIndex'),
                            getCounter(),
                            _resetAll(),
                            _showToast(
                                'Dữ liệu đã lưu nhưng Hoạt động chưa hoàn tất do không có mạng Internet - Đề nghị vào Danh sách để hoàn tất khi có mạng internet')
                          }
                      }
                  },
                  obj: const {
                    'width': 120.0,
                  },
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
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
    return SafeArea(
        child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(), child: body())),
                footer(),
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:vrp_app/component/header.dart';
import 'package:vrp_app/component/next.dart';
import 'dart:async';
import 'dart:io';
import '../civlization/civil_detail.dart';
import '../component/buttoning.dart';
import '../component/coordinate.dart';
import './people.dart';
import '../component/camera.dart';
import './civil_detail.dart';
import '../util/storage.dart';
import '../component/checker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CivilView extends StatelessWidget {
  const CivilView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // set it to false
        appBar: AppBar(
          title: const Text("Hộ dân"),
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
  _MyCivilPageState createState() => _MyCivilPageState();
}

class _MyCivilPageState extends State<MyHomePage> with WidgetsBindingObserver {
  String unitNo = "";

  int position = 0;

  Map<String, dynamic> latLong = {
    'lat': '',
    'long': '',
    'checked': false,
    'valid': false,
  };

  Map<String, dynamic> people = {
    'peopleNo': '',
    'maleNo': '',
    'femaleNo': '',
    'valid': false,
    'housePicture': '',
  };

  List<dynamic> condition_1 = <dynamic>[
    {'key': 'tinhtrang_id', 'id': 0, "title": "Hộ nghèo", 'checked': '0'},
    {'key': 'tinhtrang_id', 'id': 1, "title": "Hộ cận nghèo", 'checked': '0'},
  ];

  List<dynamic> condition_2 = <dynamic>[
    {
      'key': 'tinhtrang_congtrinh_id',
      'id': 0,
      "title": "Nhà \nkiên cố",
      'checked': '0'
    },
    {
      'key': 'tinhtrang_congtrinh_id',
      'id': 1,
      "title": "Nhà bán \nkiên cố",
      'checked': '0'
    },
    {
      'key': 'tinhtrang_congtrinh_id',
      'id': 2,
      "title": "Nhà \nđơn sơ",
      'checked': '0'
    },
  ];

  List<dynamic> detailList = <dynamic>[
    {
      'birthDay': '',
      "order": "1/x",
      'valid': false,
      'male': '0',
      'female': '0',
      'houseHold': '0',
      'singleMom': '0',
      'defected': '0',
      'vision': '0',
      'mobility': '0',
      'hearing': '0',
      'mental': '0',
      'other': '0',
    },
  ];

  List<dynamic> defectes = <dynamic>[
    'vision',
    'mobility',
    'hearing',
    'mental',
    'other',
  ];

  Map<String, dynamic> validOther = {
    'checkDetail': false,
    'checkPicture': false,
  };

  List<dynamic> fieldView = <dynamic>[];

  late XFile _image;

  bool get _validCoor {
    return latLong['lat'] == "" || latLong['long'] == "";
  }

  bool get _validDetail {
    return detailList[position]['birthDay'] == "" ||
        (detailList[position]['male'] == "0" &&
            detailList[position]['female'] == "0");
  }

  Map<String, dynamic> _mergeAll() {
    return {
      "coordinate": latLong,
      "people": people,
      "condition1": condition_1,
      "condition2": condition_2,
      "detail": detailList
    };
  }

  _resetDetailList() {
    setState(() {
      detailList.clear();
      detailList = [
        {
          'birthDay': '',
          "order": "1/${people['peopleNo'] == "" ? "x" : people['peopleNo']}",
          'valid': false,
          'male': '0',
          'female': '0',
          'houseHold': '0',
          'singleMom': '0',
          'defected': '0',
          'vision': '0',
          'mobility': '0',
          'hearing': '0',
          'mental': '0',
          'other': '0',
        }
      ];
    });
  }

  _resetAll() {
    setState(() {
      latLong = {
        'lat': '',
        'long': '',
        'checked': false,
        'valid': false,
      };

      people = {
        'peopleNo': '',
        'maleNo': '',
        'femaleNo': '',
        'valid': false,
        'housePicture': '',
      };

      condition_1 = [
        {'key': 'tinhtrang_id', 'id': 0, "title": "Hộ nghèo", 'checked': '0'},
        {
          'key': 'tinhtrang_id',
          'id': 1,
          "title": "Hộ cận nghèo",
          'checked': '0'
        },
      ];

      condition_2 = [
        {
          'key': 'tinhtrang_congtrinh_id',
          'id': 0,
          "title": "Nhà \nkiên cố",
          'checked': '0'
        },
        {
          'key': 'tinhtrang_congtrinh_id',
          'id': 1,
          "title": "Nhà bán \nkiên cố",
          'checked': '0'
        },
        {
          'key': 'tinhtrang_congtrinh_id',
          'id': 2,
          "title": "Nhà \nđơn sơ",
          'checked': '0'
        },
      ];

      position = 0;

      detailList = [
        {
          'birthDay': '',
          "order": "${position + 1}/x",
          'valid': false,
          'male': '0',
          'female': '0',
          'houseHold': '0',
          'singleMom': '0',
          'defected': '0',
          'vision': '0',
          'mobility': '0',
          'hearing': '0',
          'mental': '0',
          'other': '0',
        },
      ];
    });

    for (TextEditingController text in fieldView) {
      text.clear();
    }
  }

  _goNext() {
    setState(() {
      position += 1;

      detailList.add(
        {
          'birthDay': '',
          "order": "${position + 1}/${people['peopleNo']}",
          'valid': false,
          'male': '0',
          'female': '0',
          'houseHold': '0',
          'singleMom': '0',
          'defected': '0',
          'vision': '0',
          'mobility': '0',
          'hearing': '0',
          'mental': '0',
          'other': '0',
        },
      );
    });
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Heading(obj: {
              'start': 'THÔNG TIN CHUNG HỘ DÂN',
              'mid': 'Hộ số:',
              'end': unitNo,
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
                    color: _validCoor
                        ? const Color.fromARGB(20, 156, 156, 156)
                        : Colors.transparent,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: PeopleView(
                        onChange: (texting) {
                          String typing = texting['type'];
                          if (typing == 'fieldView') {
                            fieldView = texting['text'];
                          } else {
                            setState(() {
                              people[typing] = texting['text'];
                            });
                          }
                          if (typing == "peopleNo") {
                            _resetDetailList();
                            people['valid'] = false;
                          }
                        },
                        obj: people))),
            AbsorbPointer(
                absorbing: _validCoor,
                child: Container(
                  color: _validCoor
                      ? const Color.fromARGB(20, 156, 156, 156)
                      : Colors.transparent,
                  child: checker(),
                )),
            const Heading(obj: {
              'title': 'THÔNG TIN CHI TIẾT',
            }),
            AbsorbPointer(
                absorbing: _validCoor || people['peopleNo'] == "",
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: !validOther['checkDetail']
                              ? Colors.transparent
                              : Colors.redAccent),
                      color: _validCoor || people['peopleNo'] == ""
                          ? const Color.fromARGB(20, 156, 156, 156)
                          : Colors.transparent,
                    ),
                    child: Detailing(
                        obj: detailList[position],
                        onReset: (reset) {
                          if (reset['type'] == 'defect') {
                            setState(() {
                              for (String key in defectes) {
                                detailList[position][key] = "0";
                              }
                            });
                          }
                        },
                        onChange: (texting) {
                          setState(() {
                            String typing = texting['type'];
                            if (typing == "male" || typing == "female") {
                              _resetGender(typing);
                              setState(() {
                                validOther['checkDetail'] = false;
                              });
                            }
                            if (defectes.contains(typing)) {
                              _resetDefect(typing);
                            } else {
                              detailList[position][typing] = texting['text'];
                              if (typing == 'birthDay') {
                                setState(() {
                                  validOther['checkDetail'] = false;
                                });
                              }
                            }
                          });
                        }))),
            AbsorbPointer(
                absorbing:
                    _validCoor || people['peopleNo'] == "" || _validDetail,
                child: Container(
                    width: double.infinity,
                    height: people['peopleNo'] != "" &&
                            int.parse(people['peopleNo']) != 0 &&
                            int.parse(people['peopleNo']) - 1 > position
                        ? 80
                        : 0,
                    color:
                        _validCoor || people['peopleNo'] == "" || _validDetail
                            ? const Color.fromARGB(20, 156, 156, 156)
                            : Colors.transparent,
                    child: Next(onClickAction: () {
                      _goNext();
                    }))),
            AbsorbPointer(
                absorbing: _validCoor ||
                    people['peopleNo'] == "" ||
                    _validDetail ||
                    (position < int.parse(people['peopleNo']) - 1),
                child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: !validOther['checkPicture']
                              ? Colors.transparent
                              : Colors.redAccent),
                      color: _validCoor ||
                              people['peopleNo'] == "" ||
                              _validDetail ||
                              (position < int.parse(people['peopleNo']) - 1)
                          ? const Color.fromARGB(20, 156, 156, 156)
                          : Colors.transparent,
                    ),
                    child: CameraView(
                      title: 'Ảnh hộ gia đình',
                      obj: {"picture": people['housePicture']},
                      onClickAction: (typing) {
                        if (typing == "1") {
                          getCamera();
                        } else if (typing == "2") {
                          getGallery();
                        } else {
                          setState(() {
                            people['housePicture'] = "";
                            validOther['checkPicture'] = false;
                          });
                        }
                      },
                    ))),
          ],
        ));
  }

  _resetCondition(condition, indexing) {
    setState(() {
      if (condition[indexing]['checked'] == "0") {
        for (var con in condition) {
          con['checked'] = "0";
        }
        condition[indexing]['checked'] = "1";
      } else {
        for (var con in condition) {
          con['checked'] = "0";
        }
      }
    });
  }

  _resetGender(typing) {
    setState(() {
      if (detailList[position][typing] == "0") {
        detailList[position]['male'] = '0';
        detailList[position]['female'] = '0';
        detailList[position][typing] = "1";
      } else {
        detailList[position]['male'] = '0';
        detailList[position]['female'] = '0';
      }
    });
  }

  _resetDefect(typing) {
    setState(() {
      if (detailList[position][typing] == "0") {
        for (String key in defectes) {
          detailList[position][key] = "0";
        }
        detailList[position][typing] = "1";
      } else {
        for (String key in defectes) {
          detailList[position][key] = "0";
        }
      }
    });
  }

  Widget checker() {
    return Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tình trạng hộ/nhà:',
                textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
            Row(
                children: condition_1.map(
              (item) {
                var index = condition_1.indexOf(item);
                return Checker(
                  obj: {'title': item['title'], 'checked': item['checked']},
                  onChange: (selectedItem) {
                    _resetCondition(condition_1, index);
                  },
                );
              },
            ).toList()),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                  children: condition_2.map(
                (item) {
                  var index = condition_2.indexOf(item);
                  return Expanded(
                      child: Checker(
                    obj: {'title': item['title'], 'checked': item['checked']},
                    onChange: (selectedItem) {
                      setState(() {
                        _resetCondition(condition_2, index);
                      });
                    },
                  ));
                },
              ).toList()),
            )
          ],
        ));
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
      people['housePicture'] = image.name;
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
      people['housePicture'] = image.name;
      validOther['checkPicture'] = false;
    });
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void getCounter() async {
    int? counter = await Storing().getCounter('homeIndex');
    setState(() {
      unitNo = counter.toString();
    });
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

  bool validate() {
    if (latLong['lat'] == "" || latLong['long'] == "") {
      setState(() {
        latLong['valid'] = true;
      });
      return false;
    }

    if (people['peopleNo'] == "") {
      setState(() {
        people['valid'] = true;
      });
      return false;
    }

    if (detailList[position]['birthDay'] == "" ||
        (detailList[position]['male'] == "0" &&
            detailList[position]['female'] == "0")) {
      setState(() {
        validOther['checkDetail'] = true;
      });
      return false;
    }

    if (people['housePicture'] == "") {
      setState(() {
        validOther['checkPicture'] = true;
      });
      return false;
    }

    return true;
  }

  Column footer() {
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
                        if (!await hasNetwork())
                          {}
                        else
                          {
                            Storing().addData(
                                {'id': unitNo, 'data': _mergeAll()}, 'civil'),
                            await Storing().updateCounter('homeIndex'),
                            getCounter(),
                            _resetAll(),
                            _showToast(
                                'Dữ liệu đã lưu nhưng Hoạt động chưa hoàn tất do không có mạng Internet - Đề nghị vào Danh sách để hoàn tất khi có mạng internet')
                          }
                      },
                  },
                  obj: const {
                    'width': 120.0,
                  },
                ),
                GestureDetector(
                    onTap: () async {
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
        child: Center(
            child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                        flex: 9,
                        child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: body())),
                    footer(),
                  ],
                ))));
  }
}

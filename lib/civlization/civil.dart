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
        body: const MyHomePage());
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

  List<dynamic> fieldView = <dynamic>[];

  late File _image;

  bool get _validCoor {
    return latLong['lat'] == "" || latLong['long'] == "";
  }

  bool get _validDetail {
    return detailList[position]['birthDay'] == "" ||
        (detailList[position]['male'] == "0" &&
            detailList[position]['female'] == "0");
  }

  _resetDetailList() {
    setState(() {
      detailList.clear();
      detailList = [
        {
          'birthDay': '',
          "order": "1/${people['peopleNo']}",
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
                    color: _validCoor || people['peopleNo'] == ""
                        ? const Color.fromARGB(20, 156, 156, 156)
                        : Colors.transparent,
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
                            }
                            if (defectes.contains(typing)) {
                              _resetDefect(typing);
                            } else {
                              detailList[position][typing] = texting['text'];
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
                    color: _validCoor ||
                            people['peopleNo'] == "" ||
                            _validDetail ||
                            (position < int.parse(people['peopleNo']) - 1)
                        ? const Color.fromARGB(20, 156, 156, 156)
                        : Colors.transparent,
                    child: CameraView(
                      title: 'Ảnh hộ gia đình',
                      onClickAction: (typing) {
                        if (typing == "1") {
                          getCamera();
                        } else {
                          getGallery();
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

  void getCounter() async {
    int? counter = await Storing().getCounter('home');
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

  validate() {
    if (latLong['lat'] == "" || latLong['long'] == "") {
      setState(() {
        latLong['valid'] = true;
      });
    }
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
                    validate()
                    // await Storing().updateCounter('home'), getCounter()
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
    return Center(
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

import 'package:flutter/material.dart';
import 'package:vrp_app/component/checker.dart';
import 'package:vrp_app/component/header.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import '../component/buttoning.dart';
import '../component/coordinate.dart';
import '../component/camera.dart';
import '../component/textfield.dart';
import '../util/storage.dart';
import '../util/information.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class SchoolView extends StatelessWidget {
  final String edit;
  final Function(Map<String, dynamic>) onRefresh;

  const SchoolView({Key? key, required this.edit, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // set it to false
        appBar: AppBar(
          title: const Text(
            "TRƯỜNG HỌC",
            textAlign: TextAlign.center,
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: const Image(
            image: AssetImage('images/img_bg_head.png'),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: LoaderOverlay(
                child: MyHomePage(edit: edit, onRefresh: onRefresh))));
  }
}

class MyHomePage extends StatefulWidget {
  final String edit;
  final Function(Map<String, dynamic>) onRefresh;

  const MyHomePage({Key? key, required this.edit, required this.onRefresh})
      : super(key: key);

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

  Map<String, dynamic> schoolDetailValid = {
    'validPupil': false,
    'validTeacher': false,
    'validPeople': false,
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

  late ScrollController _scrollController;

  late XFile _image;

  Map<String, dynamic> validOther = {
    'checkPicture': false,
  };

  var pupilRelate = {
    'total': 'pupil',
    'pupilMale': {
      'index_1': "3",
      "index_2": "4",
      'key_1': 'pupilMale',
      "key_2": 'pupilFemale'
    },
    'pupilFemale': {
      'index_1': "4",
      "index_2": "3",
      'key_1': 'pupilFemale',
      "key_2": 'pupilMale'
    }
  };

  var teacherRelate = {
    'total': 'teacher',
    'teacherMale': {
      'index_1': "6",
      "index_2": "7",
      'key_1': 'teacherMale',
      "key_2": 'teacherFemale'
    },
    'teacherFemale': {
      'index_1': "7",
      "index_2": "6",
      'key_1': 'teacherFemale',
      "key_2": 'teacherMale'
    }
  };

  var peopleEvacRelate = {
    'total': 'peopleEvac',
    'peopleEvacMale': {
      'index_1': "9",
      "index_2": "10",
      'key_1': 'peopleEvacMale',
      "key_2": 'peopleEvacFemale'
    },
    'peopleEvacFemale': {
      'index_1': "10",
      "index_2": "9",
      'key_1': 'peopleEvacFemale',
      "key_2": 'peopleEvacMale'
    }
  };

  _addingSchool(data) async {
    context.loaderOverlay.show();
    var token = await Storing().getString('token');
    var postUri = Uri.parse("${Info.url}api/school");
    var request = http.MultipartRequest(
      "POST",
      postUri,
    );

    var latLong = data['coordinate'];
    var grade = data['grade'];
    var schoolDetail = data['detail'];

    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    var path = await _localPath;
    var imagePath = '$path/${schoolDetail['schoolPicture']}';
    var ext = imagePath.split('.').last;

    request.fields['lon'] = latLong['long'];
    request.fields['lat'] = latLong['lat'];

    request.fields['ten_truong'] = grade["school"];

    var gradeList = [
      {'lvl1': '1'},
      {'lvl2': '2'},
      {'lvl3': '3'},
      {'lvl4': '4'},
      {'lvl5': '5'},
      {'lvl6': '6'},
      {'lvl7': '7'},
    ];
    for (var obj in gradeList) {
      if (grade[obj.keys.first] == "1") {
        request.fields['phanloai_id'] = obj.values.first is int
            ? obj.values.first.toString()
            : obj.values.first;
        break;
      }
    }

    var conList = [
      {'con1': '1'},
      {'con2': '2'},
      {'con3': '3'},
    ];
    for (var obj in conList) {
      if (grade[obj.keys.first] == "1") {
        request.fields['tinhtrang_id'] = obj.values.first is int
            ? obj.values.first.toString()
            : obj.values.first;
        break;
      }
    }

    request.fields['so_phonghoc'] = schoolDetail['room'];
    request.fields['so_hocsinh'] = schoolDetail['pupil'];
    request.fields['so_hs_nam'] = schoolDetail['pupilMale'];
    request.fields['so_hs_nu'] = schoolDetail['pupilFemale'];

    request.fields['so_gv_cb'] = schoolDetail['teacher'];
    request.fields['so_gv_cb_nam'] = schoolDetail['teacherMale'];
    request.fields['so_gv_cb_nu'] = schoolDetail['teacherFemale'];

    request.fields['so_tiepnhan'] = schoolDetail['peopleEvac'];
    request.fields['so_tiepnhan_nam'] = schoolDetail['peopleEvacMale'];
    request.fields['so_tiepnhan_nu'] = schoolDetail['peopleEvacFemale'];

    request.files.add(http.MultipartFile.fromBytes(
        'images', await File.fromUri(Uri.parse(imagePath)).readAsBytes(),
        contentType: MediaType('image', ext)));

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    context.loaderOverlay.hide();

    if (response.statusCode != 200) {
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau');
      return;
    }
    var responseObj = jsonDecode(responseString);

    if (responseObj['status'] == "OK") {
      _showToast("Cập nhật hoàn thành");
      if (widget.edit != "-1") {
        widget.onRefresh({"index": int.parse(widget.edit)});
        Navigator.pop(context);
      } else {
        await Storing().updateCounter('schoolIndex');
        getCounter();
        _resetAll();
        _scrollToTop();
      }
    } else {
      var error = responseObj['errors'][0];
      _showToast(error['message']);
    }
  }

  Map<String, dynamic> _mergeAll() {
    return {
      "coordinate": latLong,
      "grade": gradeObj,
      "detail": schoolDetail,
    };
  }

  bool validate() {
    if (_validCoor) {
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

    if (_validPupil) {
      setState(() {
        schoolDetailValid['validPupil'] = true;
      });
      return false;
    }

    if (_validTeacher) {
      setState(() {
        schoolDetailValid['validTeacher'] = true;
      });
      return false;
    }

    if (_validPeople) {
      setState(() {
        schoolDetailValid['validPeople'] = true;
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
    Storing().initCounter();
    if (widget.edit != "-1") {
      var val =
          await Storing().getDataAt(int.parse(widget.edit) - 0, 'school') ?? [];
      var data = jsonDecode(val);
      setState(() {
        unitNo = data['id'];
      });
      _editAll();
    } else {
      int? counter = await Storing().getCounter('schoolIndex');
      setState(() {
        unitNo = counter.toString();
      });
    }
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

  bool get _validPupil {
    if (schoolDetail['pupilMale'] == "" || schoolDetail['pupilFemale'] == "") {
      return true;
    }

    if (int.parse(schoolDetail['pupilMale']) +
            int.parse(schoolDetail['pupilFemale']) !=
        int.parse(schoolDetail['pupil'])) {
      return true;
    }

    return false;
  }

  bool get _validTeacher {
    if (schoolDetail['teacherMale'] == "" ||
        schoolDetail['teacherFemale'] == "") {
      return true;
    }

    if (int.parse(schoolDetail['teacherMale']) +
            int.parse(schoolDetail['teacherFemale']) !=
        int.parse(schoolDetail['teacher'])) {
      return true;
    }

    return false;
  }

  bool get _validPeople {
    if (schoolDetail['peopleEvacMale'] == "" ||
        schoolDetail['peopleEvacFemale'] == "") {
      return true;
    }

    if (int.parse(schoolDetail['peopleEvacMale']) +
            int.parse(schoolDetail['peopleEvacFemale']) !=
        int.parse(schoolDetail['peopleEvac'])) {
      return true;
    }

    return false;
  }

  bool get _validNumber {
    return _validPupil || _validTeacher || _validPeople;
  }

  bool get _validDetail {
    for (var key in schoolDetail.keys) {
      if (schoolDetail[key] == "" && key != "schoolPicture" && key != "valid") {
        return true;
      }
    }
    return false;
  }

  _editAll() async {
    var val =
        await Storing().getDataAt(int.parse(widget.edit) - 0, 'school') ?? [];
    var data = jsonDecode(val)['data'];

    setState(() {
      latLong = data['coordinate'];

      schoolDetail = data['detail'];

      gradeObj = data['grade'];
    });

    for (var text in listText) {
      TextEditingController textField = text['text'];
      for (var key in latLong.keys) {
        if (key == text['key']) {
          textField.text = latLong[key];
        }
      }
      for (var key in schoolDetail.keys) {
        if (key == text['key']) {
          textField.text = schoolDetail[key];
        }
      }
      for (var key in gradeObj.keys) {
        if (key == text['key']) {
          textField.text = gradeObj[key];
        }
      }
    }
  }

  _resetAll() {
    setState(() {
      latLong = {
        'lat': '',
        'long': '',
        'checked': false,
        'valid': false,
      };

      schoolDetailValid = {
        'validPupil': false,
        'validTeacher': false,
        'validPeople': false,
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

    for (var text in listText) {
      TextEditingController textField = text['text'];
      textField.clear();
    }

    FocusScope.of(context).requestFocus(FocusNode());
  }

  String toast =
      'Hãy điền thông tin theo thứ tự : Nhập tọa độ -> Chỉ số Cấp, Tên trường, T.Trạng nhà -> Thông tin chi tiết Phòng học, Học sinh, GV/C.bộ, Số người sơ tán -> Ảnh chụp trường học';

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
            GestureDetector(
                onTap: () {
                  if (_validCoor) {
                    _showToast(toast);
                    validate();
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor,
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: gradeObj['valid'] == false
                                    ? Colors.transparent
                                    : Colors.redAccent)),
                        child: Column(children: [
                          level(),
                          school(),
                          condition(),
                        ])))),
            const Heading(obj: {
              'title': 'THÔNG TIN CHI TIẾT',
            }),
            GestureDetector(
                onTap: () {
                  if (_validCoor || _validHeader) {
                    _showToast(toast);
                    validate();
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor || _validHeader,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: !schoolDetail['valid']
                                ? Colors.transparent
                                : Colors.redAccent,
                          ),
                        ),
                        child: detail()))),
            GestureDetector(
                onTap: () {
                  if (_validCoor ||
                      _validHeader ||
                      _validDetail ||
                      _validNumber) {
                    _showToast(toast);
                    validate();
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor ||
                        _validHeader ||
                        _validDetail ||
                        _validNumber,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: !validOther['checkPicture']
                                  ? Colors.transparent
                                  : Colors.redAccent),
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
                        )))),
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
                const Text("Cấp:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                const Text("Tên trường:"),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 20),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: FieldView(
                        obj: {
                          "limit": 100,
                          "format": [
                            FilteringTextInputFormatter.singleLineFormatter
                          ],
                          "textAlign": TextAlign.left,
                          "text": gradeObj['school'],
                          "width": MediaQuery.of(context).size.width * 0.72,
                        },
                        onChange: (texting) {
                          if (texting.runtimeType != String) {
                            listText.add({"text": texting, "key": "school"});
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
                Text("T.Trạng nhà:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
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

  _resetRelation(typing, keys) {
    Map<String, Object>? data = keys[typing];
    String index_1 = data!['index_1'] as String;
    String index_2 = data['index_2'] as String;
    String key_1 = data['key_1'] as String;
    String key_2 = data['key_2'] as String;
    setState(() {
      schoolDetail[key_1] = "";
      schoolDetail[key_2] = "";
    });

    (listText[int.parse(index_1)]['text'] as TextEditingController).text = "";
    (listText[int.parse(index_2)]['text'] as TextEditingController).text = "";
  }

  _relation(typing, value, keys) {
    Map<String, Object>? data = keys[typing];
    String index_1 = data!['index_1'] as String;
    String index_2 = data['index_2'] as String;
    String key_1 = data['key_1'] as String;
    String key_2 = data['key_2'] as String;
    String total = keys['total'] as String;
    if (int.parse(value) > int.parse(schoolDetail[total])) {
      (listText[int.parse(index_1)]['text'] as TextEditingController).text =
          schoolDetail[total];
      (listText[int.parse(index_2)]['text'] as TextEditingController).text =
          "0";
      setState(() {
        schoolDetail[key_1] = schoolDetail[total];
        schoolDetail[key_2] = '0';
      });
    } else {
      (listText[int.parse(index_2)]['text'] as TextEditingController).text =
          (int.parse(schoolDetail[total]) - int.parse(value)).toString();
      schoolDetail[key_2] =
          (int.parse(schoolDetail[total]) - int.parse(value)).toString();
    }
  }

  Widget detail() {
    return Column(children: [
      Row(children: [
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Số phòng học   ",
              "startStyle": FontWeight.bold,
              "text": schoolDetail['room'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add({"text": texting, "key": "room"});
              } else {
                setState(() {
                  schoolDetail['room'] = texting;
                  schoolDetail['valid'] = false;
                });
              }
            })
      ]),
      Row(children: [
        const SizedBox(width: 0),
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Số học sinh       ",
              "startStyle": FontWeight.bold,
              "end": "người",
              "text": schoolDetail['pupil'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add({"text": texting, "key": "pupil"});
              } else {
                _resetRelation('pupilMale', pupilRelate);
                setState(() {
                  schoolDetail['pupil'] = texting;
                  schoolDetail['valid'] = false;
                  schoolDetailValid['validPupil'] = false;
                });
              }
            })
      ]),
      GestureDetector(
          onTap: () {
            if (schoolDetail['pupil'] == "" || schoolDetail['pupil'] == "0") {
              _showToast('Tổng số học sinh đang trống');
            }
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: AbsorbPointer(
              absorbing:
                  schoolDetail['pupil'] == "" || schoolDetail['pupil'] == "0",
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: schoolDetailValid['validPupil'] == false
                              ? Colors.transparent
                              : Colors.redAccent)),
                  margin: const EdgeInsets.fromLTRB(8, 0, 6, 0),
                  child: Row(children: [
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
                            listText.add({"text": texting, "key": "pupilMale"});
                          } else {
                            setState(() {
                              schoolDetail['pupilMale'] = texting;
                              schoolDetail['valid'] = false;
                              schoolDetailValid['validPupil'] = false;
                            });
                          }
                        },
                        onUnfocus: (texting) {
                          _relation('pupilMale', texting, pupilRelate);
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
                            listText
                                .add({"text": texting, "key": "pupilFemale"});
                          } else {
                            setState(() {
                              schoolDetail['pupilFemale'] = texting;
                              schoolDetail['valid'] = false;
                              schoolDetailValid['validPupil'] = false;
                            });
                          }
                        },
                        onUnfocus: (texting) {
                          _relation('pupilFemale', texting, pupilRelate);
                        })
                  ])))),
      Row(children: [
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Số GV/C.bộ       ",
              "startStyle": FontWeight.bold,
              "end": "người",
              "text": schoolDetail['teacher'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add({"text": texting, "key": "teacher"});
              } else {
                _resetRelation('teacherMale', teacherRelate);
                setState(() {
                  schoolDetail['teacher'] = texting;
                  schoolDetail['valid'] = false;
                  schoolDetailValid['validTeacher'] = false;
                });
              }
            })
      ]),
      GestureDetector(
          onTap: () {
            if (schoolDetail['teacher'] == "" ||
                schoolDetail['teacher'] == "0") {
              _showToast('Tổng số GV/C.bộ đang trống');
            }
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: AbsorbPointer(
              absorbing: schoolDetail['teacher'] == "" ||
                  schoolDetail['teacher'] == "0",
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: schoolDetailValid['validTeacher'] == false
                              ? Colors.transparent
                              : Colors.redAccent)),
                  margin: const EdgeInsets.fromLTRB(8, 0, 6, 0),
                  child: Row(children: [
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
                            listText
                                .add({"text": texting, "key": "teacherMale"});
                          } else {
                            setState(() {
                              schoolDetail['teacherMale'] = texting;
                              schoolDetail['valid'] = false;
                              schoolDetailValid['validTeacher'] = false;
                            });
                          }
                        },
                        onUnfocus: (texting) {
                          _relation('teacherMale', texting, teacherRelate);
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
                            listText
                                .add({"text": texting, "key": "teacherFemale"});
                          } else {
                            setState(() {
                              schoolDetail['teacherFemale'] = texting;
                              schoolDetail['valid'] = false;
                              schoolDetailValid['validTeacher'] = false;
                            });
                          }
                        },
                        onUnfocus: (texting) {
                          _relation('teacherFemale', texting, teacherRelate);
                        })
                  ])))),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.all(10),
            child: const Text('Số người có thể sơ tán phòng chống thiên tai:',
                style: TextStyle(fontWeight: FontWeight.bold)))
      ]),
      Row(children: [
        FieldView(
            obj: {
              "width": 60.0,
              "start": "Tổng số:             ",
              "startStyle": FontWeight.bold,
              "end": "người",
              "text": schoolDetail['peopleEvac'],
              "type": TextInputType.number,
            },
            onChange: (texting) {
              if (texting.runtimeType != String) {
                listText.add({"text": texting, "key": "peopleEvac"});
              } else {
                _resetRelation('peopleEvacMale', peopleEvacRelate);
                setState(() {
                  schoolDetail['peopleEvac'] = texting;
                  schoolDetail['valid'] = false;
                  schoolDetailValid['validPeople'] = false;
                });
              }
            })
      ]),
      GestureDetector(
          onTap: () {
            if (schoolDetail['peopleEvac'] == "" ||
                schoolDetail['peopleEvac'] == "0") {
              _showToast('Tổng số người có thể sơ tán đang trống');
            }
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: AbsorbPointer(
              absorbing: schoolDetail['peopleEvac'] == "" ||
                  schoolDetail['peopleEvac'] == "0",
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2,
                          color: schoolDetailValid['validPeople'] == false
                              ? Colors.transparent
                              : Colors.redAccent)),
                  margin: const EdgeInsets.fromLTRB(8, 0, 6, 0),
                  child: Row(children: [
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
                            listText.add(
                                {"text": texting, "key": "peopleEvacMale"});
                          } else {
                            setState(() {
                              schoolDetail['peopleEvacMale'] = texting;
                              schoolDetail['valid'] = false;
                              schoolDetailValid['validPeople'] = false;
                            });
                          }
                        },
                        onUnfocus: (texting) {
                          _relation(
                              'peopleEvacMale', texting, peopleEvacRelate);
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
                            listText.add(
                                {"text": texting, "key": "peopleEvacFemale"});
                          } else {
                            setState(() {
                              schoolDetail['peopleEvacFemale'] = texting;
                              schoolDetail['valid'] = false;
                              schoolDetailValid['validPeople'] = false;
                            });
                          }
                        },
                        onUnfocus: (texting) {
                          _relation(
                              'peopleEvacFemale', texting, peopleEvacRelate);
                        })
                  ])))),
    ]);
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    _scrollController = ScrollController();
    getCounter();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mess)))
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Bỏ qua"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Xóa"),
      onPressed: () {
        _resetAll();
        Navigator.pop(context);
        _scrollToTop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Thông báo"),
      content: const Text("Bạn có muốn xóa hết thông tin cập nhật?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget footer() {
    return Column(
      children: [
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
        Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Buttoning(
                  title: "Xóa",
                  onClickAction: () => {showAlertDialog(context)},
                  obj: const {
                    'width': 60.0,
                    'height': 45.0,
                    'bgColor': Color(0xFFC40021),
                    'titleColor': Colors.white,
                  },
                ),
                Buttoning(
                  title: "H.Thành/Lưu",
                  onClickAction: () async => {
                    FocusScope.of(context).requestFocus(FocusNode()),
                    if (validate())
                      {
                        if (await hasNetwork())
                          {_addingSchool(_mergeAll())}
                        else
                          {
                            if (widget.edit != "-1")
                              {
                                Storing().updateDataAt(
                                    int.parse(widget.edit),
                                    'school',
                                    {'id': unitNo, 'data': _mergeAll()}),
                                _showToast(
                                    'Dữ liệu đã lưu nhưng Hoạt động chưa hoàn tất do không có mạng Internet - Đề nghị vào Danh sách để hoàn tất khi có mạng internet'),
                                Navigator.pop(context)
                              }
                            else
                              {
                                Storing().addData(
                                    {'id': unitNo, 'data': _mergeAll()},
                                    'school'),
                                await Storing().updateCounter('schoolIndex'),
                                getCounter(),
                                _resetAll(),
                                _scrollToTop(),
                                _showToast(
                                    'Dữ liệu đã lưu nhưng Hoạt động chưa hoàn tất do không có mạng Internet - Đề nghị vào Danh sách để hoàn tất khi có mạng internet')
                              }
                          }
                      }
                  },
                  obj: const {
                    'width': 120.0,
                    'height': 45.0,
                    'bgColor': Color.fromRGBO(39, 77, 158, 1),
                    'titleColor': Colors.white,
                  },
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "images/img_home.png",
                      height: 45,
                      width: 45,
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
                        controller: _scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: body())),
                footer(),
              ],
            )));
  }
}

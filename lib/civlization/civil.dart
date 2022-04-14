import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vrp_app/component/header.dart';
import 'package:vrp_app/component/next.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
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
          title: const Text("PHÂN BỐ DÂN CƯ"),
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
            child: const LoaderOverlay(child: MyHomePage())));
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
    'validGender': false,
    'valid': false,
    'housePicture': '',
  };

  List<dynamic> condition_1 = <dynamic>[
    {'key': 'tinhtrang_id', 'id': '0', "title": "Hộ nghèo", 'checked': '0'},
    {'key': 'tinhtrang_id', 'id': '1', "title": "Hộ cận nghèo", 'checked': '0'},
  ];

  List<dynamic> condition_2 = <dynamic>[
    {
      'key': 'tinhtrang_congtrinh_id',
      'id': '0',
      "title": "Nhà \nkiên cố",
      'checked': '0'
    },
    {
      'key': 'tinhtrang_congtrinh_id',
      'id': '1',
      "title": "Nhà bán \nkiên cố",
      'checked': '0'
    },
    {
      'key': 'tinhtrang_congtrinh_id',
      'id': '2',
      "title": "Nhà \nđơn sơ",
      'checked': '0'
    },
  ];

  List<dynamic> detailList = <dynamic>[
    {
      'birthDay': '',
      "order": "1/x",
      'valid': false,
      'owner': false,
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

  late ScrollController _scrollController;

  late XFile _image;

  bool get _validCoor {
    return latLong['lat'] == "" || latLong['long'] == "";
  }

  bool get _validMem {
    return people['peopleNo'] == "" || people['peopleNo'] == "0";
  }

  bool get _validPeople {
    var con1 = condition_1.where((item) {
      return item['checked'] == "1";
    });
    var con2 = condition_2.where((item) {
      return item['checked'] == "1";
    });
    return con1.isEmpty || con2.isEmpty || _validMem;
  }

  bool get _validGender {
    bool validing = false;
    if (people['maleNo'] == "" || people['femaleNo'] == "") {
      return true;
    }

    if (int.parse(people['maleNo']) + int.parse(people['femaleNo']) !=
        int.parse(people['peopleNo'])) {
      validing = true;
    }

    return validing;
  }

  bool get _validDetail {
    return detailList[position]['birthDay'] == "" ||
        (detailList[position]['male'] == "0" &&
            detailList[position]['female'] == "0");
  }

  _addingHouse(data) async {
    context.loaderOverlay.show();
    var token = await Storing().getString('token');
    var postUri = Uri.parse("http://gisgo.vn:8016/api/household");
    var request = http.MultipartRequest(
      "POST",
      postUri,
    );

    var latLong = data['coordinate'];
    var people = data['people'];
    var condition_1 = data['condition1'];
    var condition_2 = data['condition2'];
    var detailList = data['detail'];

    request.headers.addAll({
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    });

    var path = await _localPath;
    var imagePath = '$path/${people['housePicture']}';
    var ext = imagePath.split('.').last;

    request.fields['lon'] = latLong['long'];
    request.fields['lat'] = latLong['lat'];

    var con1 = condition_1.where((item) {
      return item['checked'] == "1";
    });
    if (con1.isNotEmpty) {
      request.fields['tinhtrang_id'] = con1.first['id'];
    }

    var con2 = condition_2.where((item) {
      return item['checked'] == "1";
    });
    if (con2.isNotEmpty) {
      request.fields['tinhtrang_congtrinh_id'] = con2.first['id'];
    }

    request.fields['so_khau'] = people['peopleNo'];
    request.fields['so_nam'] = people['maleNo'] == "" ? "0" : people['maleNo'];
    request.fields['so_nu'] =
        people['femaleNo'] == "" ? "0" : people['femaleNo'];

    for (var item in detailList) {
      var indexing = detailList.indexOf(item);
      request.fields['detail[$indexing].nam_sinh'] =
          (item['birthDay']).toString().split('/').last;
      request.fields['detail[$indexing].chu_ho'] =
          item['houseHold'] == "1" ? 'true' : 'false';
      request.fields['detail[$indexing].gioi_tinh'] =
          item['male'] == "1" ? 'true' : 'false';
      request.fields['detail[$indexing].nu_donthan'] =
          item['singleMom'] == "1" ? 'true' : 'false';
      if (item['defected'] == "1") {
        var defectList = [
          {'vision': '0'},
          {'mobility': '1'},
          {'hearing': '2'},
          {'mental': '3'},
          {'other': '4'},
        ];

        for (var obj in defectList) {
          if (item[obj.keys.first] == "1") {
            request.fields['detail[$indexing].loai_khuyettat_id'] =
                obj.values.first;
            break;
          }
        }
      }
    }

    request.files.add(http.MultipartFile.fromBytes(
        'images', await File.fromUri(Uri.parse(imagePath)).readAsBytes(),
        contentType: MediaType('image', ext)));

    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var responseObj = jsonDecode(responseString);

    context.loaderOverlay.hide();
    if (response.statusCode != 200) {
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau');
      return;
    }
    if (responseObj['status'] == "OK") {
      _showToast("Cập nhật hoàn thành");
      await Storing().updateCounter('homeIndex');
      getCounter();
      _resetAll();
      _scrollToTop();
    } else {
      var error = responseObj['errors'][0];
      _showToast(error['message']);
    }
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
          "order": "1/${_validMem ? "x" : people['peopleNo']}",
          'valid': false,
          'owner': false,
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
        'validGender': false,
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
          'id': '0',
          "title": "Nhà \nkiên cố",
          'checked': '0'
        },
        {
          'key': 'tinhtrang_congtrinh_id',
          'id': '1',
          "title": "Nhà bán \nkiên cố",
          'checked': '0'
        },
        {
          'key': 'tinhtrang_congtrinh_id',
          'id': '2',
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
          'owner': false,
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
    FocusScope.of(context).requestFocus(FocusNode());
  }

  _goNext() {
    setState(() {
      position += 1;

      var checkOwner = detailList.where((item) {
        return item['houseHold'] == "1";
      });

      detailList.add(
        {
          'birthDay': '',
          "order": "${position + 1}/${people['peopleNo']}",
          'valid': false,
          'owner': checkOwner.isNotEmpty,
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

  String toast =
      'Hãy điền thông tin theo thứ tự : Nhập tọa độ -> Số người, Tình trạng hộ/nhà -> Thông tin thứ tự số người -> Ảnh chụp gia đình';

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
                      if (mounted)
                        {
                          setState(() {
                            latLong = coordinate;
                          })
                        }
                    }),
            GestureDetector(
                onTap: () {
                  if (_validCoor) {
                    _showToast(toast);
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor,
                    child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                        child: Container(
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
                                      people['valid'] = false;
                                      people['validGender'] = false;
                                    });
                                  }
                                  if (typing == "peopleNo") {
                                    _resetDetailList();
                                    setState(() {
                                      people['valid'] = false;
                                      people['validGender'] = false;
                                    });
                                  }
                                },
                                obj: people))))),
            GestureDetector(
                onTap: () {
                  if (_validCoor) {
                    _showToast(toast);
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                        left: BorderSide(
                          color: people['valid'] == false
                              ? Colors.transparent
                              : Colors.redAccent,
                          width: 2.0,
                        ),
                        bottom: BorderSide(
                          color: people['valid'] == false
                              ? Colors.transparent
                              : Colors.redAccent,
                          width: 2.0,
                        ),
                        right: BorderSide(
                          color: people['valid'] == false
                              ? Colors.transparent
                              : Colors.redAccent,
                          width: 2.0,
                        ),
                      )),
                      child: checker(),
                    ))),
            const Heading(obj: {
              'title': 'THÔNG TIN CHI TIẾT',
            }),
            GestureDetector(
                onTap: () {
                  if (_validCoor || _validPeople || _validGender) {
                    _showToast(toast);
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor || _validPeople || _validGender,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: !validOther['checkDetail']
                                  ? Colors.transparent
                                  : Colors.redAccent),
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
                              if (reset['type'] == 'gender') {
                                setState(() {
                                  detailList[position]["singleMom"] = "0";
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
                                  detailList[position][typing] =
                                      texting['text'];
                                  if (typing == 'birthDay') {
                                    setState(() {
                                      validOther['checkDetail'] = false;
                                    });
                                  }
                                }
                              });
                            })))),
            GestureDetector(
                onTap: () {
                  if (_validCoor ||
                      _validPeople ||
                      _validGender ||
                      _validDetail) {
                    _showToast(toast);
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: _validCoor ||
                        _validPeople ||
                        _validGender ||
                        _validDetail,
                    child: SizedBox(
                        width: double.infinity,
                        height: people['peopleNo'] != "" &&
                                int.parse(people['peopleNo']) != 0 &&
                                int.parse(people['peopleNo']) - 1 > position
                            ? 85
                            : 0,
                        child: Next(onClickAction: () {
                          _goNext();
                        })))),
            GestureDetector(
                onTap: () {
                  if (_validCoor ||
                      _validPeople ||
                      _validGender ||
                      _validDetail ||
                      (position < int.parse(people['peopleNo']) - 1)) {
                    _showToast(toast);
                  }
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: AbsorbPointer(
                    absorbing: //false,
                        _validCoor ||
                            _validPeople ||
                            _validGender ||
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
                        )))),
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
      people['valid'] = false;
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
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
    Storing().initCounter();
    int? counter = await Storing().getCounter('homeIndex');
    setState(() {
      unitNo = counter.toString();
    });
  }

  @override
  initState() {
    WidgetsBinding.instance?.addObserver(this);
    _scrollController = ScrollController();
    super.initState();
    getCounter();
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

  bool validate() {
    if (_validCoor) {
      setState(() {
        latLong['valid'] = true;
      });
      return false;
    }

    if (_validPeople) {
      setState(() {
        people['valid'] = true;
      });
      return false;
    }

    if (_validGender) {
      setState(() {
        people['validGender'] = true;
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

  Column footer() {
    return Column(
      children: [
        const Divider(
          height: 2,
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
                          {_addingHouse(_mergeAll())}
                        else
                          {
                            Storing().addData(
                                {'id': unitNo, 'data': _mergeAll()}, 'civil'),
                            await Storing().updateCounter('homeIndex'),
                            getCounter(),
                            _resetAll(),
                            _scrollToTop(),
                            _showToast(
                                'Dữ liệu đã lưu nhưng Hoạt động chưa hoàn tất do không có mạng Internet - Đề nghị vào Danh sách để hoàn tất khi có mạng internet')
                          }
                      },
                  },
                  obj: const {
                    'width': 120.0,
                    'height': 45.0,
                    'bgColor': Color.fromRGBO(39, 77, 158, 1),
                    'titleColor': Colors.white,
                  },
                ),
                GestureDetector(
                    onTap: () async {
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
        child: Center(
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
                ))));
  }
}

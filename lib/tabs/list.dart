import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../util/storage.dart';

class Listing extends StatelessWidget {
  final String title;

  const Listing({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // set it to false
        appBar: AppBar(
          title: const Text("Danh sách"),
          automaticallyImplyLeading: true,
        ),
        body: const LoaderOverlay(child: Option()));
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> rowData = <dynamic>[];

  String _selectedGender = '0';

  @override
  void initState() {
    super.initState();
    _initData('civil');
    // context.loaderOverlay.show();
  }

  void _initData(type) async {
    var list = await Storing().getAllData(type) ?? [];
    setState(() {
      rowData = list;
    });
    // print(list);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Row radios() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 1,
            child: Row(children: [
              Radio<String>(
                value: '0',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                  _initData('civil');
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'D.Sách hộ dân',
                maxLines: 2,
                style: TextStyle(fontSize: 14),
              ),
            ])),
        Expanded(
            flex: 1,
            child: Row(children: [
              Radio<String>(
                value: '1',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                  _initData('school');
                },
                activeColor: Colors.greenAccent,
              ),
              const Text(
                'D.Sách trường học',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                softWrap: true,
                style: TextStyle(fontSize: 14),
              ),
            ])),
      ],
    );
  }

  Future<bool> hasNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Widget card(object, pos) {
    var data = object['data'];
    var id = object['id'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Image.asset("images/img_logos.png",
                    height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_selectedGender == "0" ? "Hộ" : "Trường"} số $id',
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Expanded(
                          flex: 1,
                          child: Row(children: [
                            const Text(
                              'K.dộ:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                                child: Text(data['coordinate']['lat'] ?? '',
                                    maxLines: 1)),
                          ])),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 1,
                          child: Row(children: [
                            const Text(
                              'V.độ:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Flexible(
                                child: Text(data['coordinate']['long'] ?? '',
                                    maxLines: 1)),
                          ]))
                    ])
                  ],
                )),
            DropdownButton<String>(
              underline: const SizedBox(),
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              items: <String>['Tải lên', 'Xóa'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (opt) async {
                if (opt == "Tải lên") {
                  if (await hasNetwork()) {
                    _showToast(
                        'Mạng kết nối không khả dụng, vui lòng thử lại sau.');
                    return;
                  }
                  context.loaderOverlay.show();
                  if (_selectedGender == "0") {
                    _addingHouse(data, pos);
                  } else {
                    _addingSchool(data, pos);
                  }
                } else {
                  _refreshData(pos);
                }
              },
            )
            // const Expanded(flex: 1, child:
            //  Icon(Icons.more_vert)
            //  )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        radios(),
        Expanded(
            child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: rowData.length,
          itemBuilder: (context, pos) {
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: card(jsonDecode(rowData[pos]), pos),
                  ),
                ));
          },
        ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _refreshData(pos) {
    Storing().delDataAt(pos, _selectedGender == "0" ? "civil" : "school");
    _initData(_selectedGender == "0" ? "civil" : "school");
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  _addingHouse(data, pos) async {
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
      _refreshData(pos);
    } else {
      var error = responseObj['errors'][0];
      _showToast(error['message']);
    }
  }

  _addingSchool(data, pos) async {
    var token = await Storing().getString('token');
    var postUri = Uri.parse("http://gisgo.vn:8016/api/school");
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
      {'lvl1': '0'},
      {'lvl2': '1'},
      {'lvl3': '2'},
      {'lvl4': '3'},
      {'lvl5': '4'},
      {'lvl6': '5'},
      {'lvl7': '6'},
    ];
    for (var obj in gradeList) {
      if (grade[obj.keys.first] == "1") {
        request.fields['phanloai_id'] = obj.values.first;
        break;
      }
    }

    var conList = [
      {'con1': '0'},
      {'con2': '1'},
      {'con3': '2'},
    ];
    for (var obj in conList) {
      if (grade[obj.keys.first] == "1") {
        request.fields['tinhtrang_id'] = obj.values.first;
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
    var responseObj = jsonDecode(responseString);

    context.loaderOverlay.hide();

    if (response.statusCode != 200) {
      _showToast('Server xảy ra lỗi, mời bạn thử lại sau');
      return;
    }

    if (responseObj['status'] == "OK") {
      _showToast("Cập nhật hoàn thành");
      _refreshData(pos);
    } else {
      var error = responseObj['errors'][0];
      _showToast(error['message']);
    }
  }

  _showToast(mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(mess),
    ));
  }
}

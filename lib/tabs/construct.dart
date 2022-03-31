import 'package:flutter/material.dart';
import '../component/check.dart';
import '../component/check1.dart';
import '../component/buttoning.dart';
import '../component/input.dart';
import '../component/camera.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ContructView extends StatelessWidget {
  final String title;

  const ContructView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Option());
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option>
    with AutomaticKeepAliveClientMixin {
  List<dynamic> listing = <dynamic>[];

  String name = "";

  late File _image;

  final picker = ImagePicker();

  _resetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Row input() {
    return Row(
      children: [
        const Text(
          'Tên công trình:',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: InputView(
                obj: const {"hintText": ""},
                onChange: (selectedItem) {
                  setState(() {
                    // obj = selectedItem;
                  });
                }))
      ],
    );
  }

  Row input_1() {
    return Row(
      children: [
        const Text(
          'Số người có thể sơ tán đến:',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: InputView(
                obj: const {"hintText": "", "type": TextInputType.number},
                onChange: (selectedItem) {
                  setState(() {
                    // obj = selectedItem;
                  });
                }))
      ],
    );
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

  Column header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
            child: Text(
              'Nhà/Công trình số: 001',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Buttoning(
              title: "Nhận tọa độ",
              onClickAction: () => {},
              obj: const {
                'borderColor': Colors.greenAccent,
                'titleColor': Colors.black,
              },
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 1,
                child: Row(children: const [
                  Text(
                    'Kinh độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text('12.00000', maxLines: 1)),
                ])),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: Row(children: const [
                  Text(
                    'Vĩ độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text('12.1436332434', maxLines: 1)),
                ])),
          ],
        ),
        const SizedBox(height: 15),
        input(),
        CheckCard(
          title: 'Loại công trình',
          obj: {},
          onSelectionChanged: (selectedItem) {
            setState(() {
              // obj = selectedItem;
            });
          },
        ),
        CheckCard1(
          title: 'Loại công trình',
          obj: {},
          onSelectionChanged: (selectedItem) {
            setState(() {
              // obj = selectedItem;
            });
          },
        ),
        const SizedBox(height: 15),
        input_1(),
        const SizedBox(height: 15),
        const Text(
          'Hình ảnh Nhà/Công trình:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        CameraView(
          onClickAction: (typing) {
            if (typing == "1") {
              getCamera();
            } else {
              getGallery();
            }
          },
        ),
      ],
    );
  }

  Row footer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Buttoning(
          title: "Hủy",
          onClickAction: () => {},
          obj: {
            "width": (MediaQuery.of(context).size.width / 2) - 20,
            'bgColor': Colors.redAccent,
            'titleColor': Colors.white,
          },
        ),
        Buttoning(
          title: "Cập nhật",
          onClickAction: () => {},
          obj: {
            "width": (MediaQuery.of(context).size.width / 2) - 20,
            'bgColor': Colors.greenAccent,
            'titleColor': Colors.white,
          },
        ),
      ],
    );
  }

  Widget body(BuildContext context) {
    return Column(children: [
      Expanded(
          flex: 9,
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 15.0),
                      header(),
                    ],
                  )))),
      Container(
          alignment: Alignment.center, height: 55, child: footer(context)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  bool get wantKeepAlive => true;
}

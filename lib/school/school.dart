import 'package:flutter/material.dart';
import 'package:vrp_app/component/header.dart';
import 'package:vrp_app/component/next.dart';
import 'dart:async';
import 'dart:io';
import '../civlization/civil_detail.dart';
import '../component/buttoning.dart';
import '../component/coordinate.dart';
import '../component/camera.dart';
import '../component/next.dart';
import 'package:image_picker/image_picker.dart';

class SchoolView extends StatelessWidget {
  const SchoolView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
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
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Map<String, dynamic> latLong = {
    'lat': '-',
    'long': '-',
  };

  Map<String, dynamic> people = {
    'peopleNo': '',
    'maleNo': '',
    'femaleNo': '',
  };

  late File _image;

  final picker = ImagePicker();

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
            const Heading(obj: {
              'title': 'THÔNG TIN CHI TIẾT',
            }),
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

  Column footer() {
    return Column(
      children: [
        const Divider(
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
                  onClickAction: () => {print(latLong)},
                  obj: const {
                    'width': 60.0,
                  },
                ),
                Buttoning(
                  title: "H.Thành/Lưu",
                  onClickAction: () => {},
                  obj: const {
                    'width': 120.0,
                  },
                ),
                GestureDetector(
                    onTap: () {},
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
        child: Column(
      children: [
        Expanded(
            flex: 9,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(), child: body())),
        footer(),
      ],
    ));
  }
}

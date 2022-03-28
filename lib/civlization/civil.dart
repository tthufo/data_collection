import 'package:flutter/material.dart';
import 'package:vrp_app/component/header.dart';
import '../component/buttoning.dart';
import '../component/coordinate.dart';

class CivilView extends StatelessWidget {
  const CivilView({Key? key}) : super(key: key);

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

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Heading(obj: {
              'start': 'THÔNG TIN CHUNG HỘ DÂN',
              'mid': 'Hộ số:',
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
            const SizedBox(height: 25.0),
          ],
        ));
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
            // color: Colors.grey,
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

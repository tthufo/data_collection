import 'package:flutter/material.dart';
import './component/buttoning.dart';
import './civlization/civil.dart';
import './school/school.dart';
import './tabs/list.dart';

class OptionView extends StatelessWidget {
  const OptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                // image: DecorationImage(
                //   image: AssetImage("images/bg_img.png"),
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
            const Center(
              child: Center(child: MyHomePage()),
            )
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: const Text(""),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Image.asset("images/img_logos.png",
                height: 120, width: 120, fit: BoxFit.cover),
            const SizedBox(height: 15.0),
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.yellow,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("LỰA CHỌN ĐỐI TƯỢNG NHẬP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                    Text("THÔNG TIN - DỮ LIỆU",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                )),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "HỘ DÂN",
              onClickAction: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CivilView()))
              },
              obj: {
                'borderColor': Colors.blue,
                'titleColor': Colors.black,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 20.0
              },
            ),
            // const SizedBox(height: 25.0),
            // Buttoning(
            //   title: "NHÀ VĂN HÓA",
            //   onClickAction: () => {},
            //   obj: {
            //     'borderColor': Colors.black,
            //     'titleColor': Colors.black,
            //     'width': MediaQuery.of(context).size.width * 0.6,
            //     'height': 50.0,
            //     'fontSize': 20.0
            //   },
            // ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "TRƯỜNG HỌC",
              onClickAction: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const SchoolView()))
              },
              obj: {
                'borderColor': Colors.blue,
                'titleColor': Colors.black,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 20.0
              },
            ),
            const SizedBox(height: 25.0),
            Buttoning(
              title: "DANH SÁCH",
              onClickAction: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const Listing(title: 'Danh sách')))
              },
              obj: {
                'borderColor': Colors.blue,
                'titleColor': Colors.black,
                'width': MediaQuery.of(context).size.width * 0.7,
                'height': 50.0,
                'fontSize': 20.0
              },
            ),
            // const SizedBox(height: 25.0),
            // Buttoning(
            //   title: "BỆNH VIỆN",
            //   onClickAction: () => {},
            //   obj: {
            //     'borderColor': Colors.black,
            //     'titleColor': Colors.black,
            //     'width': MediaQuery.of(context).size.width * 0.6,
            //     'height': 50.0,
            //     'fontSize': 20.0
            //   },
            // ),
            // const SizedBox(height: 25.0),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 9,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(), child: body())),
      ],
    );
  }
}

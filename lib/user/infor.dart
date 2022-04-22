import 'package:flutter/material.dart';
import '../component/buttoning.dart';
import './edit.dart';

class InforView extends StatefulWidget {
  const InforView({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InforView> {
  @override
  initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return Column(
      children: [
        top(),
        Expanded(
            flex: 8,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    mid(),
                  ],
                )))),
        const Divider(
          height: 2,
          color: Colors.grey,
        ),
        Expanded(flex: 2, child: footer()),
      ],
    );
  }

  Widget top() {
    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: const AssetImage('images/img_bg_head.png'),
            width: MediaQuery.of(context).size.width,
            height: 150,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 50),
          Container(
              child: Column(children: [
            Text("Tài chột",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Text("Quản trị viên",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "THÔNG TIN CÁ NHÂN",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                )),
            Divider(
              height: 2,
              color: Colors.grey,
            ),
          ])),
        ],
      ),
      Positioned(
          left: 5.0,
          top: 5.0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () => {Navigator.pop(context)},
          )),
    ]);
  }

  Widget element(obj) {
    return Container(
        margin: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(obj['title'],
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(obj['detail'],
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
        ]));
  }

  Widget mid() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      element({'title': 'Họ và tên', 'detail': 'Phạm Tài chột'}),
      element({'title': 'Họ và tên', 'detail': 'Phạm Tài chột'}),
      element({'title': 'Họ và tên', 'detail': 'Phạm Tài chột'}),
      element({
        'title': 'Họ và tên',
        'detail': 'Phạm Tài chộ s  sf asf sf asdf asf asf asf asf asf sft'
      }),
    ]);
  }

  Widget footer() {
    return SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Buttoning(
              title: "Cập nhật thông tin",
              onClickAction: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditView()))
              },
              obj: {
                'bgColor': const Color.fromRGBO(39, 77, 158, 1),
                'titleColor': Colors.white,
                'width': MediaQuery.of(context).size.width - 30,
                'height': 50.0,
                'fontSize': 18.0,
              },
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: const Image(
            image: AssetImage('images/img_bg_head.png'),
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
            ),
            Center(
              child: Center(child: body()),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width / 2) - 75,
              top: 50.0,
              child: const Image(
                image: AssetImage('images/img_Ava.png'),
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ));
  }
}

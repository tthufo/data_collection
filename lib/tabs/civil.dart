import 'package:flutter/material.dart';

class CivilView extends StatelessWidget {
  final String title;

  const CivilView({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(child: Center(child: Option()));
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option> with WidgetsBindingObserver {
  List<dynamic> rowData = <dynamic>[];

  String _selectedGender = '0';

  @override
  void initState() {
    super.initState();
    setState(() {
      rowData = [1, 2, 3];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  Column card() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: EdgeInsets.all(10), child: Text('Hộ số: 001')),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buttoning(onClickAction: () => {}),
            Expanded(
                flex: 1,
                child: Row(children: [
                  Text(
                    'Kinh độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text('12.1436332434', maxLines: 1)),
                ])),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: Row(children: [
                  Text(
                    'Vĩ độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text('12.1436332434', maxLines: 1)),
                ])),
          ],
        )
      ],
    );
  }

  Container buttoning({required Function onClickAction}) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent),
            borderRadius: BorderRadius.circular(10.0)),
        margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            child: SizedBox(
              width: 100,
              height: 35,
              child: MaterialButton(
                minWidth: 60,
                height: 40,
                onPressed: () {
                  onClickAction();
                },
                child: const Text(
                  "Nhận tọa độ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.greenAccent,
                    fontSize: 12.0,
                  ),
                ),
              ),
            )));
  }

  Widget body() {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15.0),
            card(),
            Container(
              child: const Text(""),
              color: Colors.grey,
              height: MediaQuery.of(context).size.height * 0.06,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }
}

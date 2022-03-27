import 'package:flutter/material.dart';
import '../component/civil_card.dart';
import '../component/buttoning.dart';
import 'package:geolocator/geolocator.dart';

class CivilView extends StatelessWidget {
  final String title;

  const CivilView({Key? key, required this.title}) : super(key: key);

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
  bool checkedValue = false;

  Map<String, dynamic> obj = {
    'title': 'Người thứ 1 (chủ hộ):',
    'birthDay': '',
    'gender': '0',
    'defect': '0',
  };

  List<dynamic> listing = <dynamic>[];

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Position currPos = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);

    // print(currPos.altitude);

    return await Geolocator.getCurrentPosition();
  }

  _resetState() {
    setState(() {
      listing.clear();
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        listing.add(obj);
      });
    });
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

  _addMember() {
    Map<String, dynamic> objd = {
      'title': 'Người thứ ${listing.length + 1}:',
      'birthDay': '',
      'gender': '0',
      'defect': '0',
    };
    setState(() {
      listing.add(objd);
    });
  }

  Column header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 20),
            child: Text(
              'Hộ số: 001',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.bold),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Buttoning(
              title: "Nhận tọa độ",
              onClickAction: () => {print(_determinePosition())},
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
                  Flexible(child: Text('12.', maxLines: 1)),
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
        Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.greenAccent,
                  value: checkedValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedValue = !checkedValue;
                    });
                  },
                ),
                const Text(
                  "Hộ nghèo",
                  style: TextStyle(fontSize: 14),
                )
              ],
            ))
      ],
    );
  }

  Widget addRow() {
    return Column(
        children: listing.map(
      (item) {
        var index = listing.indexOf(item);
        return CivilCard(
          title: item['title'],
          obj: item,
          onSelectionChanged: (selectedItem) {
            setState(() {
              listing[index] = selectedItem;
            });
          },
        );
      },
    ).toList());
  }

  Row footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Buttoning(
          title: "Thêm người",
          onClickAction: () => {_addMember()},
          obj: const {
            'bgColor': Colors.blueAccent,
            'titleColor': Colors.white,
          },
        ),
        Buttoning(
          title: "Hủy",
          onClickAction: () => {_resetState()},
          obj: const {
            'bgColor': Colors.redAccent,
            'titleColor': Colors.white,
          },
        ),
        Buttoning(
          title: "Cập nhật",
          onClickAction: () => {print(listing)},
          obj: const {
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
                      const SizedBox(height: 10.0),
                      header(),
                      addRow(),
                    ],
                  )))),
      Expanded(child: footer()),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  @override
  bool get wantKeepAlive => true;
}

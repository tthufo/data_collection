import 'package:flutter/material.dart';
import '../component/textfield.dart';

class PeopleView extends StatefulWidget {
  final Function(Map<String, dynamic>) onChange;
  final Map<String, dynamic> obj;

  const PeopleView({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyPeoplePageState createState() => _MyPeoplePageState();
}

class _MyPeoplePageState extends State<PeopleView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => widget.onChange({'type': 'fieldView', 'text': listText}));
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<dynamic> listText = <dynamic>[];

  Column header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: FieldView(
              obj: {
                "limit": 2,
                "start": "Số người",
                "startStyle": FontWeight.bold,
                "end": "người",
                "text": widget.obj['peopleNo'],
                "type": TextInputType.number,
              },
              onChange: (texting) {
                if (texting.runtimeType != String) {
                  listText.add(texting);
                } else {
                  widget.onChange({'text': texting, 'type': 'peopleNo'});
                }
              }),
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2,
                      color: widget.obj['validGender'] == false
                          ? Colors.transparent
                          : Colors.redAccent)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FieldView(
                      obj: {
                        "limit": 2,
                        "pre": "Trong đó:",
                        "start": "Nam",
                        "end": "người",
                        "text": widget.obj['maleNo'],
                        "type": TextInputType.number,
                      },
                      onChange: (texting) {
                        if (texting.runtimeType != String) {
                          listText.add(texting);
                        } else {
                          widget.onChange({'text': texting, 'type': 'maleNo'});
                        }
                      }),
                  FieldView(
                      obj: {
                        "limit": 2,
                        "pre": "Trong đó:",
                        "hiddenPre": "1",
                        "start": "   Nữ",
                        "end": "người",
                        "text": widget.obj['femaleNo'],
                        "type": TextInputType.number,
                      },
                      onChange: (texting) {
                        if (texting.runtimeType != String) {
                          listText.add(texting);
                        } else {
                          widget
                              .onChange({'text': texting, 'type': 'femaleNo'});
                        }
                      }),
                  // Buttoning(
                  //   title: "Nhận tọa độ",
                  //   onClickAction: () => {
                  //     for (TextEditingController text in listText) {text.clear()}
                  //   },
                  //   obj: const {
                  //     'borderColor': Colors.greenAccent,
                  //     'titleColor': Colors.black,
                  //   },
                  // ),
                ],
              )),
        ),
        // checker(),
      ],
    );
  }

  // Widget checker() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('Tình trạng hộ/nhà:',
  //           textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
  //       Row(
  //           children: listing.map(
  //         (item) {
  //           return Checker(
  //             obj: item,
  //             onChange: (selectedItem) {
  //               setState(() {});
  //             },
  //           );
  //         },
  //       ).toList()),
  //       SizedBox(
  //         width: MediaQuery.of(context).size.width,
  //         child: Row(
  //             children: listing_1.map(
  //           (item) {
  //             return Expanded(
  //                 child: Checker(
  //               obj: item,
  //               onChange: (selectedItem) {
  //                 setState(() {});
  //               },
  //             ));
  //           },
  //         ).toList()),
  //       )
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(
            color: widget.obj['valid'] == false
                ? Colors.transparent
                : Colors.redAccent,
            width: 2.0,
          ),
          top: BorderSide(
            color: widget.obj['valid'] == false
                ? Colors.transparent
                : Colors.redAccent,
            width: 2.0,
          ),
          right: BorderSide(
            color: widget.obj['valid'] == false
                ? Colors.transparent
                : Colors.redAccent,
            width: 2.0,
          ),
        )),
        child: header());
  }
}

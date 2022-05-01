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

  bool get _validGender {
    return widget.obj['peopleNo'] == "" || widget.obj['peopleNo'] == "0";
  }

  _showToast(mess) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mess)))
        .closed
        .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
  }

  _relation(typing, value) {
    var keys = {
      'maleNo': {
        'index_1': "1",
        "index_2": "2",
        'key_1': 'maleNo',
        "key_2": 'femaleNo'
      },
      'femaleNo': {
        'index_1': "2",
        "index_2": "1",
        'key_1': 'femaleNo',
        "key_2": 'maleNo'
      }
    };

    Map<String, Object>? data = keys[typing];
    String index_1 = data!['index_1'] as String;
    String index_2 = data['index_2'] as String;
    String key_1 = data['key_1'] as String;
    String key_2 = data['key_2'] as String;

    if (int.parse(value) > int.parse(widget.obj['peopleNo'])) {
      (listText[int.parse(index_1)]['text'] as TextEditingController).text =
          widget.obj['peopleNo'];
      widget.onChange({'text': widget.obj['peopleNo'], 'type': key_1});

      (listText[int.parse(index_2)]['text'] as TextEditingController).text =
          "0";
      widget.onChange({'text': '0', 'type': key_2});
    } else {
      (listText[int.parse(index_2)]['text'] as TextEditingController).text =
          (int.parse(widget.obj['peopleNo']) - int.parse(value)).toString();
      widget.onChange({
        'text':
            (int.parse(widget.obj['peopleNo']) - int.parse(value)).toString(),
        'type': key_2
      });
    }
  }

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
                  listText.add({"text": texting, "key": "peopleNo"});
                } else {
                  widget.onChange({'text': texting, 'type': 'peopleNo'});
                }
              }),
        ),
        GestureDetector(
            onTap: () {
              if (_validGender) {
                _showToast("Tổng số người đang trống");
              }
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: AbsorbPointer(
                absorbing: _validGender,
                child: SizedBox(
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
                                  listText
                                      .add({"text": texting, "key": "maleNo"});
                                } else {
                                  widget.onChange(
                                      {'text': texting, 'type': 'maleNo'});
                                }
                              },
                              onUnfocus: (texting) {
                                Future.delayed(const Duration(milliseconds: 0),
                                    () {
                                  _relation('maleNo', texting);
                                });
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
                                  listText.add(
                                      {"text": texting, "key": "femaleNo"});
                                } else {
                                  widget.onChange(
                                      {'text': texting, 'type': 'femaleNo'});
                                }
                              },
                              onUnfocus: (texting) {
                                Future.delayed(const Duration(milliseconds: 0),
                                    () {
                                  _relation('femaleNo', texting);
                                });
                              }),
                        ],
                      )),
                ))),
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

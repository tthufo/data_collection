import 'package:flutter/material.dart';
import '../component/textfield.dart';
import '../component/checker.dart';

class PeopleView extends StatefulWidget {
  final Function(Map<String, dynamic>) onChange;
  final Map<String, dynamic> obj;

  const PeopleView({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<PeopleView> {
  bool checkedValue = false;
  List<dynamic> listing = <dynamic>[
    {"title": "Hộ nghèo"},
    {"title": "Hộ cận nghèo"},
  ];

  List<dynamic> listing_1 = <dynamic>[
    {"title": "Nhà \nkiên cố"},
    {"title": "Nhà bán \nkiên cố"},
    {"title": "Nhà \nđơn sơ"},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Column header() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: FieldView(
              obj: {
                "start": "Số người",
                "end": "người",
                "text": widget.obj['peopleNo'],
                "type": TextInputType.number,
              },
              onChange: (texting) {
                setState(() {
                  widget.onChange({'text': texting, 'type': 'peopleNo'});
                });
              }),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FieldView(
                  obj: {
                    "pre": "Trong đó:",
                    "start": "Nam",
                    "end": "người",
                    "text": widget.obj['maleNo'],
                    "type": TextInputType.number,
                  },
                  onChange: (texting) {
                    setState(() {
                      widget.onChange({'text': texting, 'type': 'maleNo'});
                    });
                  }),
              FieldView(
                  obj: {
                    "pre": "Trong đó:",
                    "hiddenPre": "1",
                    "start": "   Nữ",
                    "end": "người",
                    "text": widget.obj['femaleNo'],
                    "type": TextInputType.number,
                  },
                  onChange: (texting) {
                    setState(() {
                      widget.onChange({'text': texting, 'type': 'femaleNo'});
                    });
                  })
            ],
          ),
        ),
        checker(),
      ],
    );
  }

  Widget checker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tình trạng hộ/nhà:',
            textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
        Row(
            children: listing.map(
          (item) {
            return Checker(
              obj: item,
              onChange: (selectedItem) {
                setState(() {});
              },
            );
          },
        ).toList()),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
              children: listing_1.map(
            (item) {
              return Expanded(
                  child: Checker(
                obj: item,
                onChange: (selectedItem) {
                  setState(() {});
                },
              ));
            },
          ).toList()),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
        child: header());
  }
}

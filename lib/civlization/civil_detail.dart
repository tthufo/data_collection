import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../component/checker.dart';

class Detailing extends StatefulWidget {
  final Map<String, dynamic> obj;

  final Function(Map<String, dynamic>) onChange;
  final Function(Map<String, dynamic>) onReset;

  const Detailing(
      {Key? key,
      required this.obj,
      required this.onChange,
      required this.onReset})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Detailing> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        header(),
        mid(),
        AbsorbPointer(
            absorbing: widget.obj['defected'] == "0",
            child: Container(
                color: widget.obj['defected'] == "0"
                    ? const Color.fromARGB(20, 156, 156, 156)
                    : Colors.transparent,
                child: Row(
                  children: [
                    const Expanded(flex: 2, child: Text('')),
                    Expanded(flex: 8, child: end())
                  ],
                )))
      ],
    );
  }

  String getYear() {
    String birthDay = widget.obj['birthDay'] ?? "";
    if (birthDay == "") {
      return "";
    }
    var now = DateTime.now();
    var formatter = DateFormat('yyyy');
    String formattedDate = formatter.format(now);

    return (int.parse(formattedDate) - int.parse(birthDay.split('/')[2]))
        .toString();
  }

  Widget header() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(
        children: [
          Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    Text(
                      'Người thứ ${widget.obj['order'] ?? ''} :',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                            height: 30,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4.0)),
                            child: Text(widget.obj['birthDay'] ?? ''))),
                    const SizedBox(width: 10),
                    const Text('Năm sinh'),
                    const SizedBox(width: 10),
                    Text(
                      "${getYear()} tuổi",
                      style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 12),
                    )
                  ],
                )),
          ),
        ],
      ),
      Row(
        children: [
          Text(
            'Người thứ ${widget.obj['order'] ?? ''} :',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.transparent,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Checker(
            obj: {'title': 'Nam', 'checked': widget.obj['male']},
            onChange: (selectedItem) {
              widget.onChange({'text': selectedItem, "type": 'male'});
            },
          ),
          Checker(
            obj: {'title': 'Nữ', 'checked': widget.obj['female']},
            onChange: (selectedItem) {
              widget.onChange({'text': selectedItem, "type": 'female'});
            },
          )
        ],
      ),
    ]);
  }

  Widget mid() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Đặc điểm:',
                textAlign: TextAlign.start, style: TextStyle(fontSize: 14)),
            Row(
              children: [
                Checker(
                  obj: {
                    'title': 'Là chủ hộ',
                    'checked': widget.obj['houseHold']
                  },
                  onChange: (selectedItem) {
                    widget
                        .onChange({'text': selectedItem, "type": 'houseHold'});
                  },
                ),
                Checker(
                  obj: {
                    'title': 'Là phụ nữ đơn thân',
                    'checked': widget.obj['singleMom']
                  },
                  onChange: (selectedItem) {
                    widget
                        .onChange({'text': selectedItem, "type": 'singleMom'});
                  },
                )
              ],
            ),
            Row(
              children: [
                Checker(
                  obj: {
                    'title': 'Là người khuyết tật',
                    'checked': widget.obj['defected']
                  },
                  onChange: (selectedItem) {
                    widget.onChange({'text': selectedItem, "type": 'defected'});
                    if (selectedItem == "0") {
                      widget.onReset({'type': 'defect'});
                    }
                  },
                )
              ],
            )
          ],
        ));
  }

  Widget end() {
    return SizedBox(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nếu là người khuyết tật, xin chi tiết',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
        Row(
          children: [
            Checker(
              obj: {'title': 'Nhìn', 'checked': widget.obj['vision']},
              onChange: (selectedItem) {
                widget.onChange({'text': selectedItem, "type": 'vision'});
              },
            ),
            Checker(
              obj: {'title': 'Vận động', 'checked': widget.obj['mobility']},
              onChange: (selectedItem) {
                widget.onChange({'text': selectedItem, "type": 'mobility'});
              },
            ),
            Checker(
              obj: {'title': 'Nghe/nói', 'checked': widget.obj['hearing']},
              onChange: (selectedItem) {
                widget.onChange({'text': selectedItem, "type": 'hearing'});
              },
            )
          ],
        ),
        Row(
          children: [
            Checker(
              obj: {'title': 'Thần kinh', 'checked': widget.obj['mental']},
              onChange: (selectedItem) {
                widget.onChange({'text': selectedItem, "type": 'mental'});
              },
            ),
            Checker(
              obj: {'title': 'Khác', 'checked': widget.obj['other']},
              onChange: (selectedItem) {
                widget.onChange({'text': selectedItem, "type": 'other'});
              },
            )
          ],
        )
      ],
    ));
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        String birthDay = DateFormat('dd/MM/yyyy').format(selectedDate);
        widget.onChange({'text': birthDay, "type": 'birthDay'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.obj['valid'] == false
                    ? Colors.transparent
                    : Colors.redAccent)),
        child: body());
  }
}

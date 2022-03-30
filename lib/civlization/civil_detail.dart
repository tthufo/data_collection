import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../component/checker.dart';

class Detailing extends StatefulWidget {
  final Map<String, dynamic> obj;

  final Function(Map<String, dynamic>) onSelectionChanged;

  const Detailing(
      {Key? key, required this.obj, required this.onSelectionChanged})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Detailing> {
  String _selectedGender = '0';

  bool checkedValue = false;

  String birthDay = "";

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
        Row(
          children: [
            const Expanded(flex: 2, child: Text('')),
            Expanded(flex: 8, child: end())
          ],
        )
      ],
    );
  }

  Widget header() {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Row(
        children: [
          Expanded(
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
                        child: Text(birthDay))),
                const SizedBox(width: 10),
                const Text('Năm sinh'),
                const SizedBox(width: 10),
                const Text(
                  'tuổi',
                  style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                )
              ],
            ),
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
            obj: {'title': 'Nam'},
            onChange: (selectedItem) {
              setState(() {});
            },
          ),
          Checker(
            obj: {'title': 'Nữ'},
            onChange: (selectedItem) {
              setState(() {});
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
                  obj: {'title': 'Là chủ hộ'},
                  onChange: (selectedItem) {
                    setState(() {});
                  },
                ),
                Checker(
                  obj: {'title': 'Là phụ nữ đơn thân'},
                  onChange: (selectedItem) {
                    setState(() {});
                  },
                )
              ],
            ),
            Row(
              children: [
                Checker(
                  obj: {'title': 'Là người khuyết tật'},
                  onChange: (selectedItem) {
                    setState(() {});
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
              obj: {'title': 'Nhìn'},
              onChange: (selectedItem) {
                setState(() {});
              },
            ),
            Checker(
              obj: {'title': 'Vận động'},
              onChange: (selectedItem) {
                setState(() {});
              },
            ),
            Checker(
              obj: {'title': 'Nghe/nói'},
              onChange: (selectedItem) {
                setState(() {});
              },
            )
          ],
        ),
        Row(
          children: [
            Checker(
              obj: {'title': 'Thần kinh'},
              onChange: (selectedItem) {
                setState(() {});
              },
            ),
            Checker(
              obj: {'title': 'Khác'},
              onChange: (selectedItem) {
                setState(() {});
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
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthDay = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
        child: body());
  }
}

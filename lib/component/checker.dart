import 'package:flutter/material.dart';

class Checker extends StatefulWidget {
  final Function(String) onChange;
  final Map<String, dynamic> obj;

  const Checker({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Checker> {
  bool checkedValue = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      checkedValue =
          widget.obj["checked"] == null ? false : widget.obj["checked"] == "1";
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obj["checked"] != widget.obj["checked"]) {
      setState(() {
        checkedValue = widget.obj["checked"] == "1";
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget header() {
    return Row(
      children: [
        SizedBox(
            height: 25.0,
            width: 25.0,
            child: Checkbox(
              side: MaterialStateBorderSide.resolveWith(
                (states) => BorderSide(
                    width: 1.5,
                    color: widget.obj["disable"] == true
                        ? Colors.grey
                        : Colors.blueAccent),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
              checkColor: Colors.white,
              activeColor: Colors.blueAccent,
              value: checkedValue,
              onChanged: widget.obj["disable"] == true
                  ? null
                  : (bool? value) {
                      setState(() {
                        checkedValue = !checkedValue;
                      });
                      widget.onChange(value == true ? "1" : "0");
                    },
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          widget.obj['title'] ?? '',
          maxLines: 2,
          style: TextStyle(
              fontSize: 14,
              color:
                  widget.obj["disable"] == true ? Colors.grey : Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(5), child: header());
  }
}

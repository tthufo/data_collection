import 'package:flutter/material.dart';

class FieldView extends StatefulWidget {
  final Function(String) onChange;

  final Map<String, dynamic> obj;

  const FieldView({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FieldView> {
  static final TextEditingController _textController = TextEditingController();

  @override
  initState() {
    super.initState();
    _textController.text = widget.obj["text"];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget inputField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.obj['pre'] != null
            ? Text(widget.obj['pre'],
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: widget.obj['hiddenPre'] != null
                      ? Colors.transparent
                      : Colors.grey,
                ))
            : const SizedBox(),
        const SizedBox(
          width: 10,
        ),
        Text(widget.obj['start'],
            style: const TextStyle(
              fontSize: 14,
            )),
        Container(
            alignment: Alignment.center,
            width: widget.obj['width'] ?? 100,
            height: widget.obj['height'] ?? 35,
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: TextField(
              controller: _textController,
              obscureText: false,
              maxLength: 2,
              keyboardType: widget.obj['type'] ?? TextInputType.text,
              onChanged: (text) {
                setState(() {
                  widget.onChange(text);
                });
              },
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                counterText: "",
                contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                isDense: true,
                hintText: widget.obj['hintText'] ?? "",
                hintStyle: const TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            )),
        widget.obj['end'] != null
            ? Text(widget.obj['end'],
                style: const TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey))
            : const SizedBox()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return inputField();
  }
}

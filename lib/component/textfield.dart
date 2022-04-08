import 'package:flutter/material.dart';

class FieldView extends StatefulWidget {
  final Function(dynamic) onChange;

  final Map<String, dynamic> obj;

  const FieldView({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FieldView> {
  final TextEditingController _textController = TextEditingController();

  @override
  initState() {
    super.initState();
    _textController.text = widget.obj["text"];
    widget.onChange(_textController);
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obj["text"] != widget.obj["text"]) {
      // _textController.text = widget.obj["text"];
    }
  }

  @override
  void dispose() {
    super.dispose();
    // _textController.dispose();
  }

  Widget inputField() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.obj['pre'] != null
            ? Text(widget.obj['pre'] ?? '',
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
        Text(widget.obj['start'] ?? '',
            style: TextStyle(
              fontSize: 14,
              fontWeight: widget.obj['startStyle'] ?? FontWeight.normal,
            )),
        Container(
            alignment: Alignment.center,
            width: widget.obj['width'] ?? 80,
            height: widget.obj['height'] ?? 35,
            margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: TextField(
              textAlign: widget.obj['textAlign'] ?? TextAlign.center,
              controller: _textController,
              obscureText: false,
              maxLength: widget.obj['limit'] ?? 2,
              keyboardType: widget.obj['type'] ?? TextInputType.text,
              onChanged: (text) {
                widget.onChange(text);
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
                  borderRadius: BorderRadius.circular(5.0),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
              ),
            )),
        widget.obj['end'] != null
            ? Text(widget.obj['end'] ?? '',
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

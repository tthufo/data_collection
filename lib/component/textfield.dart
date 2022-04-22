import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final FocusNode _focus = FocusNode();

  @override
  initState() {
    super.initState();
    _textController.text = widget.obj["text"] ?? '';
    _focus.addListener(_onFocusChange);
    widget.onChange(_textController);
  }

  void _onFocusChange() {
    if (_focus.hasFocus.toString() == "false") {
      String formated = _textController.text == ""
          ? '0'
          : _textController.text.replaceFirst(RegExp(r'^0+'), "") == ""
              ? "0"
              : _textController.text.replaceFirst(RegExp(r'^0+'), "");

      widget.onChange(formated);
      _textController.text = formated;
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (oldWidget.obj["text"] != widget.obj["text"]) {
    //   // _textController.text = widget.obj["text"];
    // }
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
              focusNode: _focus,
              textAlign: widget.obj['textAlign'] ?? TextAlign.center,
              controller: _textController,
              obscureText: false,
              maxLength: widget.obj['limit'] ?? 4,
              keyboardType: widget.obj['type'] ?? TextInputType.text,
              inputFormatters: widget.obj['format'] ??
                  [FilteringTextInputFormatter.digitsOnly],
              onChanged: (text) {
                widget.onChange(text);
              },
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: widget.obj['fontSize'] ?? 17.0,
                fontWeight: widget.obj['fontWeight'] ?? FontWeight.normal,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                counterText: "",
                contentPadding: widget.obj['underLine'] != null
                    ? const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0)
                    : const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                isDense: true,
                hintText: widget.obj['hintText'] ?? "",
                hintStyle: const TextStyle(color: Colors.black),
                border: widget.obj['underLine'] != null
                    ? const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      )
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                focusedBorder: widget.obj['underLine'] != null
                    ? const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      )
                    : const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.5),
                      ),
                enabledBorder: widget.obj['underLine'] != null
                    ? const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      )
                    : const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blueAccent, width: 1.5),
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

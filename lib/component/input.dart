import 'package:flutter/material.dart';

class InputView extends StatefulWidget {
  final Function(String) onChange;

  final Map<String, dynamic> obj;

  const InputView({Key? key, required this.onChange, required this.obj})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InputView> {
  static final TextEditingController _textController = TextEditingController();

  String name = "";

  @override
  initState() {
    super.initState();
    _textController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget inputField() {
    return Container(
        alignment: Alignment.center,
        child: TextField(
          obscureText: false,
          keyboardType: widget.obj['type'] ?? TextInputType.text,
          onChanged: (text) {
            setState(() {
              name = text;
              widget.onChange(text);
            });
          },
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17.0,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            // filled: true,
            // fillColor: Colors.white.withOpacity(0.5),
            contentPadding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
            isDense: true,
            // contentPadding: EdgeInsets.zero,
            hintText: widget.obj['hintText'] ?? "",
            hintStyle: const TextStyle(color: Colors.black),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return inputField();
  }
}

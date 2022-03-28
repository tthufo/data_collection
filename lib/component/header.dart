import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final Map<String, dynamic> obj;

  const Heading({Key? key, required this.obj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buttoning(context);
  }

  Container buttoning(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        color: Colors.yellowAccent,
        width: MediaQuery.of(context).size.width,
        child: obj['title'] != null
            ? Text(
                obj['title'],
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    obj['start'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Row(
                    children: [
                      Text(
                        obj['mid'],
                        style: const TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        obj['end'],
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  )
                ],
              ));
  }
}

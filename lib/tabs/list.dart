import 'package:flutter/material.dart';

class Listing extends StatelessWidget {
  final String title;

  const Listing({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Option();
  }
}

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Option> with WidgetsBindingObserver {
  List<dynamic> rowData = <dynamic>[];

  String _selectedGender = '0';

  @override
  void initState() {
    super.initState();
    setState(() {
      rowData = [1, 2, 3];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
  }

  Row radios() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            flex: 1,
            child: ListTile(
              leading: Radio<String>(
                value: '0',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              title: const Text(
                'Danh sách dân cư',
                style: TextStyle(fontSize: 14),
              ),
            )),
        Expanded(
            flex: 1,
            child: ListTile(
              leading: Radio<String>(
                value: '1',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                activeColor: Colors.greenAccent,
              ),
              title: const Text(
                'Danh sách công trình',
                style: TextStyle(fontSize: 14),
              ),
            )),
      ],
    );
  }

  Container card(object) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Image.asset("images/img_logos.png",
                    height: 50, width: 50, fit: BoxFit.cover)),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'can hoj',
                      maxLines: 1,
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'kinh ddooj vix ddooj',
                      maxLines: 1,
                      style: TextStyle(color: Colors.redAccent, fontSize: 14),
                    ),
                  ],
                )),
            const Expanded(flex: 1, child: Icon(Icons.more_vert))
          ],
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        radios(),
        Expanded(
            child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: rowData.length,
          itemBuilder: (context, pos) {
            return Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    child: card(rowData[pos]),
                  ),
                ));
          },
        ))
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class CoordinateView extends StatefulWidget {
  final Function(Map<String, dynamic>) onChange;
  final Map<String, dynamic> latLong;

  const CoordinateView(
      {Key? key, required this.onChange, required this.latLong})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CoordinateView> {
  bool checkedValue = false;
  bool loading = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position currPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    widget.onChange({
      'lat': currPos.latitude.toString(),
      'long': currPos.longitude.toString(),
      'valid': false,
    });

    setState(() {
      loading = false;
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    if (widget.latLong['lat'] != '' && widget.latLong['long'] != '') {
      setState(() {
        checkedValue = true;
      });
    }
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latLong["valid"] != widget.latLong["valid"]) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Column header() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  "Vị trí:",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                    height: 24.0,
                    width: 24.0,
                    child: loading
                        ? const CircularProgressIndicator()
                        : Checkbox(
                            checkColor: Colors.white,
                            activeColor: Colors.greenAccent,
                            value: checkedValue,
                            onChanged: (bool? value) {
                              setState(() {
                                checkedValue = !checkedValue;
                                if (checkedValue) {
                                  setState(() {
                                    loading = true;
                                  });
                                  _determinePosition();
                                } else {
                                  widget.onChange(
                                      {'lat': '', 'long': '', 'valid': false});
                                }
                              });
                            },
                          )),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  "Nhận vị trí",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                flex: 1,
                child: Row(children: [
                  const Text(
                    'K.dộ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text(widget.latLong['lat'], maxLines: 1)),
                ])),
            const SizedBox(
              width: 5,
            ),
            Expanded(
                flex: 1,
                child: Row(children: [
                  const Text(
                    'V.độ:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text(widget.latLong['long'], maxLines: 1)),
                ])),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          '(Bấm vào ô để thiết bị tự động nhận tọa độ)',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
                width: 2,
                color: widget.latLong['valid'] == false
                    ? Colors.transparent
                    : Colors.redAccent)),
        child: header());
  }
}

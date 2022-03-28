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

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position currPos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    widget.onChange({
      'lat': currPos.latitude.toString(),
      'long': currPos.longitude.toString()
    });

    setState(() {
      loading = false;
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Row header() {
    return Row(
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
                    ? CircularProgressIndicator()
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
                              widget.onChange({'lat': '-', 'long': '-'});
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.redAccent)),
        child: header());
  }
}

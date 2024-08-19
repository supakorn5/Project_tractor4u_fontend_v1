import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:tractor4your/page/customer/workplace/addworkplace.dart';
import 'package:tractor4your/page/customer/workplace/workplace.dart';

class MapPage extends StatefulWidget {
  final int? id;
  const MapPage({Key? key, this.id}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  final List<Marker> _markers = [];
  int? Id;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    Id = widget.id;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "MAP",
            style: TextStyle(fontFamily: "Prompt", color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: _currentPosition == null
            ? Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "กำลังโหลด...",
                      textStyle: const TextStyle(
                        fontFamily: "Prompt",
                        fontSize: 25,
                      ),
                      colors: [
                        const Color.fromARGB(255, 38, 53, 93),
                        const Color.fromARGB(255, 175, 71, 210),
                        const Color.fromARGB(255, 255, 143, 0),
                        const Color.fromARGB(255, 255, 219, 0),
                      ],
                    ),
                  ],
                ),
              )
            : GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  ),
                  zoom: 14.0,
                ),
                onTap: _handleTap,
                markers: Set<Marker>.of(_markers),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: _sendMarkerData,
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  void _handleTap(LatLng tappedPoint) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'คุณต้องการเลือกที่ดินตรงนี้ ?',
              style: TextStyle(fontFamily: "Prompt"),
            ),
            content: const Text(
              'ใช่ที่ดินของคุณแล้วใช่ใหม่',
              style: TextStyle(fontFamily: "Prompt"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'ไม่',
                  style: TextStyle(fontFamily: "Prompt"),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _markers.add(
                      Marker(
                        markerId: MarkerId(tappedPoint.toString()),
                        position: tappedPoint,
                        infoWindow: InfoWindow(
                          title: 'ตำแหน่งที่ดินของคุณ',
                          snippet: tappedPoint.toString(),
                        ),
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('ยืนยัน',
                    style: TextStyle(fontFamily: "Prompt")),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _getCurrentLocation() async {
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

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          ),
          infoWindow: const InfoWindow(
            title: 'ตำแหน่งของคุณ',
          ),
        ),
      );
      _mapController?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            zoom: 14.0,
          ),
        ),
      );
    });
  }

  void _sendMarkerData() {
    int index = 0;
    // Prepare marker data to send
    List<Map<String, dynamic>> markerData = [];
    for (Marker marker in _markers) {
      if (index == 0) {
      } else {
        markerData.add({
          'index': index,
          'landinfo': "",
          'rai': "",
          'ngan': "",
          'latitude': marker.position.latitude,
          'longitude': marker.position.longitude,
        });
      }
      index += 1;
    }

    // Send marker data to another file
    // Replace 'YourDestinationFile' with the actual file where you want to send the data
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Addworkplace(mapdata: markerData, id: Id),
      ),
    );
  }
}

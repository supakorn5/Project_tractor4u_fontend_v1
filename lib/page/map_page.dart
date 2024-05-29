import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const LatLng _pGoogle = LatLng(37.4223, -122.0848);

  // List to hold markers
  final List<Marker> _markers = [];

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
            style: TextStyle(fontFamily: "Itim"),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              //color: Colors.transparent,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: GoogleMap(
          initialCameraPosition:
              const CameraPosition(target: _pGoogle, zoom: 15),
          onTap: _handleTap,
          markers: Set<Marker>.of(_markers),
        ),
      ),
    );
  }

  // Function to handle tap on map
  void _handleTap(LatLng tappedPoint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Location'),
          content: const Text('Do you want to mark this location?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without marking
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _markers.add(
                    Marker(
                      markerId: MarkerId(tappedPoint.toString()),
                      position: tappedPoint,
                      infoWindow: InfoWindow(
                        title: 'Tapped Location',
                        snippet: tappedPoint.toString(),
                      ),
                    ),
                  );
                });
                Navigator.of(context)
                    .pop(); // Close the dialog and mark the location
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'makeReserve.dart';

class SelectOwner extends StatefulWidget {
  const SelectOwner({super.key});

  @override
  State<SelectOwner> createState() => _SelectOwnerState();
}

class _SelectOwnerState extends State<SelectOwner> {
  late GoogleMapController mapController;
  late LatLng _center;

  //List of Owner's Locations
  final Set<Marker> _markers = {};

  //Current land's location
  double landLat = 16.2424;
  double landLon = 103.254;

  //List of Owner Infomation
  List<dynamic> ownersData = [];

  @override
  void initState() {
    super.initState();
    _center = LatLng(landLat, landLon);
    _SelectOwnerOpen();
  }

  void _addMarkers() {
    setState(() {
      for (int i = 0; i < ownersData.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId(ownersData[i]['owners_id'].toString()),
            position:
                LatLng(ownersData[i]['users_lat'], ownersData[i]['users_lon']),
            // infoWindow: InfoWindow(
            //   title: '${ownersData[i]['users_username']}', // Owner's name or ID
            //   snippet: 'Description',
            // ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => makeReserve(ownersData: ownersData[i]),
                ),
              );
            },
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // void _getImageBase64() async {
  //   http.Response response = await http.get(Uri.parse(
  //       'https://protocoderspoint.com/wp-content/uploads/2022/09/Whats-New-in-Flutter-3.3-696x392.jpg'));

  //   var _base64 = base64Encode(response.bodyBytes);
  //   print("------------this is base64---------------");
  //   print(_base64);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 177, 122),
        title: const Text(
          "เลือกเข้าของรถไถ",
          style: TextStyle(fontFamily: "Itim"),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        color: Colors.amber,
        child: _buildGoogleMap(),
      ),
    ));
  }

  //Show Google Maps
  @override
  Widget _buildGoogleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 14.0,
      ),
      //markers: _markers,
      markers: Set<Marker>.of(_markers),
    );
  }


  Future<void> _SelectOwnerOpen() async {
    final url = Uri.parse(
        "http://10.0.2.4:5000/api/owners/GetOwnersOpen"); //My laptop
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      ownersData = decodeResponse['data'];
      //print("---------------this is data----------------------");
      //print(ownersData[1]['owners_id']);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
    _addMarkers();
  }
}

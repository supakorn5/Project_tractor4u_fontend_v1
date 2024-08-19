import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tractor4your/page/customer/workplace/map_page.dart';
import 'package:tractor4your/page/customer/workplace/workplace.dart';
import 'package:http/http.dart' as http;

class Addworkplace extends StatefulWidget {
  final double? latitude;
  final double? longitude;
  final int? id;
  final List<Map<String, dynamic>> mapdata;

  const Addworkplace(
      {Key? key, this.latitude, this.longitude, this.id, required this.mapdata})
      : super(key: key);

  @override
  State<Addworkplace> createState() => _AddworkplaceState();
}

class _AddworkplaceState extends State<Addworkplace> {
  double? _Lat;
  double? _Lon;
  late int _ID;
  late List<Map<String, dynamic>> mapdata = [];

  // Lists of TextEditingControllers for each index
  List<TextEditingController> landinfoControllers = [];
  List<TextEditingController> raiControllers = [];
  List<TextEditingController> nganControllers = [];

  @override
  void initState() {
    super.initState();
    _Lat = widget.latitude;
    _Lon = widget.longitude;
    _ID = widget.id!;
    mapdata = widget.mapdata;

    // Initialize the TextEditingController lists
    for (var i = 0; i < mapdata.length; i++) {
      landinfoControllers.add(TextEditingController());
      raiControllers.add(TextEditingController());
      nganControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose the controllers to free up resources
    for (var controller in landinfoControllers) {
      controller.dispose();
    }
    for (var controller in raiControllers) {
      controller.dispose();
    }
    for (var controller in nganControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "เพิ่มตำแหน่งของงาน",
            style: TextStyle(fontFamily: "Prompt"),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Workplace(id: _ID),
              ));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  mapdata.isEmpty
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(320, 50),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MapPage(id: _ID),
                            ));
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Image(
                                  image: AssetImage("assets/icon/map.png"),
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              Text(
                                "เพิ่มตำแหน่งของที่ทำงาน",
                                style: TextStyle(
                                  fontFamily: "Prompt",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                          itemCount: mapdata.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ที่ดินที่ ${mapdata[index]['index']}",
                                      style: const TextStyle(
                                        fontFamily: "Prompt",
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: TextFormField(
                                    controller: landinfoControllers[index],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      labelText: "กรอกข้อมูลที่ดิน",
                                      labelStyle:
                                          TextStyle(fontFamily: "Prompt"),
                                      hintText:
                                          "เช่น นายายศรี ข้างบ้านลุงหมื่น ใกล้ๆเมรุ",
                                      hintStyle:
                                          TextStyle(fontFamily: "Prompt"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: TextFormField(
                                    controller: raiControllers[index],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      labelText: "กรอกข้อมูลจำนวนไร่",
                                      labelStyle:
                                          TextStyle(fontFamily: "Prompt"),
                                      hintText: "เช่น 15 ไร่ 20 ไร่",
                                      hintStyle:
                                          TextStyle(fontFamily: "Prompt"),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: TextFormField(
                                    controller: nganControllers[index],
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      labelText: "กรอกข้อมูลจำนวนงาน",
                                      labelStyle:
                                          TextStyle(fontFamily: "Prompt"),
                                      hintText: "เช่น 3 งาน 1 งาน",
                                      hintStyle:
                                          TextStyle(fontFamily: "Prompt"),
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: SizedBox(
                      width: 320,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 246, 177, 122),
                        ),
                        onPressed: () {
                          try {
                            for (var i = 0; i < mapdata.length; i++) {
                              mapdata[i]['landinfo'] =
                                  landinfoControllers[i].text;
                              mapdata[i]['rai'] =
                                  raiControllers[i].text.isNotEmpty
                                      ? int.parse(raiControllers[i].text)
                                      : 0;
                              mapdata[i]['ngan'] =
                                  nganControllers[i].text.isNotEmpty
                                      ? int.parse(nganControllers[i].text)
                                      : 0;
                              _addnewlands(
                                  mapdata[i]['landinfo'],
                                  mapdata[i]['rai'],
                                  mapdata[i]['ngan'],
                                  mapdata[i]['latitude'],
                                  mapdata[i]['longitude'],
                                  _ID);
                            }
                            addlandcomplete(_ID);
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: const Text(
                          "ยืนยัน",
                          style: TextStyle(
                            fontFamily: "Prompt",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addnewlands(String landinfoControllers, int raiControllers,
      int nganControllers, double lat, double lon, int id) async {
    final url = Uri.parse(
        "http://10.0.2.47:5000/api/lands/Addnewlands"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "lands_info": landinfoControllers,
      "lands_rai": raiControllers,
      "lands_ngan": nganControllers,
      "lands_lat": lat,
      "lands_lon": lon,
      "lands_user_id": id
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }

  Future<dynamic> addlandcomplete(int id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'บันทึกข้อมูลสำเร็จ',
            style: TextStyle(fontFamily: "Prompt"),
          ),
          content: const Text(
            'ไปกันต่อ !!!!!!',
            style: TextStyle(fontFamily: "Prompt"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Workplace(id: id),
                )); // Close the dialog
              },
              child: const Text('ตกลง'),
            ),
          ],
        );
      },
    );
  }
}

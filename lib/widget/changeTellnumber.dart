import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Ipglobals.dart';
import 'package:http/http.dart' as http;

class changeTellNum extends StatefulWidget {
  final int? id;
  changeTellNum({super.key, this.id});

  @override
  State<changeTellNum> createState() => _changeTellNumState();
}

class _changeTellNumState extends State<changeTellNum> {
  final _tellController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 210,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "เปลี่ยนเบอร์โทรศัพท์",
                style: TextStyle(fontFamily: "Prompt", fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _tellController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16)),
                    labelText: "เบอร์โทรศัพท์",
                    labelStyle: TextStyle(fontFamily: "Prompt")),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(a, r, g, b)),
                  onPressed: () {
                    if (_tellController.text != null) {
                      log(_tellController.text);
                      updataTellNumber();
                      Get.back(result: 1);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ยืนยัน",
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<void> updataTellNumber() async {
    final url = Uri.parse(
        "http://${IPGlobals}:5000/api/users/updateTellnumber"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({"users_Tell": _tellController.text, "user_id": widget.id});
    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("${data}");
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }
}

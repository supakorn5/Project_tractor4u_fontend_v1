import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Ipglobals.dart';
import 'package:tractor4your/Start/Register.dart';
import 'package:tractor4your/page/Owner/Owner_mainMenu.dart';
import 'package:tractor4your/page/Owner/menu/JOB/job.dart';
import 'package:tractor4your/page/customer/workplace/workplace.dart';
import 'package:http/http.dart' as http;

class Login_Page extends StatefulWidget {
  const Login_Page({Key? key});

  @override
  State<Login_Page> createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final _formKey = GlobalKey<FormState>();
  final usersController = TextEditingController();
  final passwordController = TextEditingController();
  bool passToggle = true;
  List<int> userData = [0, 0];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.32,
                  child: Stack(
                    children: [
                      Positioned(
                          child: Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/image/welcome.png"),
                                fit: BoxFit.fill)),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "เข้าสู่ระบบ",
                        style: TextStyle(
                            fontFamily: "Prompt",
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextFormField(
                    controller: usersController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.userLarge),
                        prefixIconColor: Colors.black,
                        labelText: "กรอกชื่อผู้ใช้งาน",
                        labelStyle: TextStyle(fontFamily: "Prompt"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกชื่อผู้ใช้";
                      }
                      if (RegExp(r'[ก-๙]').hasMatch(value)) {
                        return 'ชื่อผู้ใช้ห้ามมีตัวอักษรภาษาไทย';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextFormField(
                    obscureText: passToggle,
                    controller: passwordController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(FontAwesomeIcons.lock),
                        prefixIconColor: Colors.black,
                        labelText: "รหัสผ่าน",
                        labelStyle: TextStyle(fontFamily: "Prompt"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            icon: passToggle
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off))),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "กรุณากรอกรหัสผ่าน";
                      }
                      if (RegExp(r'[ก-๙]').hasMatch(value)) {
                        return 'ชื่อผู้ใช้ห้ามมีตัวอักษรภาษาไทย';
                      }
                      return null;
                    },
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(320, 50),
                        backgroundColor: Color.fromARGB(a, r, g, b)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _Login(usersController, passwordController);
                        log("Users ID : ${userData[0]}");
                        log("Users Type : ${userData[1]}");
                        if (userData.isNotEmpty) {
                          log("Navigating to the next page");
                          if (userData[1] == 0) {
                            log("Navigating to Workplace with id: ${userData[0]}");
                            Get.off(() => Workplace(
                                  id: userData[0],
                                ));
                          } else if (userData[1] == 1) {
                            log("Navigating to Job with id: 3");
                            Get.off(() => Owner_mainMenu(
                                  id: userData[0],
                                ));
                          } else {
                            log("Unhandled user type: ${userData[1]}");
                          }
                        } else {
                          log("Login failed, userData is empty");
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                fontFamily: "Prompt",
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ),
                        Icon(
                          FontAwesomeIcons.arrowRightLong,
                          color: Colors.black,
                        )
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ยังไม่เป็นสมาชิก?",
                      style: TextStyle(fontFamily: "Prompt"),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(() => Register_page());
                        },
                        child: Text(
                          "สมัครสมาชิก",
                          style: TextStyle(
                              fontFamily: "Prompt", color: Colors.blue),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _Login(
      TextEditingController users, TextEditingController password) async {
    final url = Uri.parse(
        "http://${IPGlobals}:5000/api/users/LoginUsers"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "users_username": users.text,
      "users_password": password.text,
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (response.body.isNotEmpty) {
        setState(() {
          userData[0] = data['data']['users_id'];
          userData[1] = data['data']['users_type'];
        });
      }
    } else {
      Get.snackbar("เข้าสู่ระบบไม่สำเร็จ", "ตรวจสอบข้อมูลของคุณ");
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tractor4your/Start/Register.dart';
import 'package:tractor4your/page/Owner/Owner_mainMenu.dart';
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
  List<int> userData = []; // Initialized with default values

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(
                        fontFamily: "Prompt",
                        fontSize: 50,
                        color: Color.fromARGB(255, 246, 177, 122)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextFormField(
                      controller: usersController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        labelText: "กรอกชื่อผู้ใช้",
                        labelStyle: TextStyle(
                          fontFamily: "Prompt",
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        String pattern = r'^[a-zA-Z0-9]{0,500}$';
                        RegExp regex = RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกชื่อผู้ใช้";
                        } else if (!regex.hasMatch(value)) {
                          return 'ตรวจสอบชื่อผู้ใช้ของคุณว่ามี อักขระพิเศษ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          labelText: "กรอกหัสผ่าน",
                          labelStyle: const TextStyle(
                            fontFamily: "Prompt",
                            color: Colors.black,
                          ),
                          prefixIcon: const Icon(
                            FontAwesomeIcons.unlockKeyhole,
                            color: Colors.black,
                          ),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            child: Icon(
                              passToggle
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 30,
                            ),
                          )),
                      obscureText: passToggle,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกรหัสผ่าน";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("คุณยังไม่เป็นสมามาชิก ?",
                            style: TextStyle(
                              fontFamily: "Prompt",
                              color: Colors.black,
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Register_page(),
                                  ));
                            },
                            child: const Text(
                              "สมัครสมาชิก",
                              style: TextStyle(
                                  fontFamily: "Prompt",
                                  color: Color.fromARGB(255, 246, 177, 122)),
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      width: 300,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 246, 177, 122)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _Login(usersController, passwordController);
                              if (userData.isNotEmpty) {
                                if (userData[1] == 0) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Workplace(id: userData[0])));
                                } else {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Owner_mainMenu(id: userData[0])));
                                }
                              } else {
                                // Handle login failure
                                print("Login failed");
                              }
                            }
                          },
                          child: const Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Prompt",
                                color: Colors.black),
                          )),
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

  Future<void> _Login(
      TextEditingController users, TextEditingController password) async {
    final url = Uri.parse(
        "http://192.168.96.151:5000/api/users/LoginUsers"); // Replace with your machine's IP address
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
          userData.add(data['data']['users_id']);
          userData.add(data['data']['users_type']);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'เข้าสู่ระบบล้มเหลว',
          style: TextStyle(fontFamily: "Prompt"),
        )),
      );
      print("Login failed with status code: ${response.statusCode}");
    }
  }
}

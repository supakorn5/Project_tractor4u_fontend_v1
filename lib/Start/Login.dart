import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tractor4your/Start/Register.dart';
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
                        fontFamily: "Itim",
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
                          fontFamily: "Itim",
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
                            fontFamily: "Itim",
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
                              fontFamily: "Itim",
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
                                  fontFamily: "Itim",
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _Login(usersController, passwordController);
                            }
                          },
                          child: const Text(
                            "เข้าสู่ระบบ",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Itim",
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
        "http://192.168.165.188:5000/api/users/LoginUsers"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "users_username": users.text,
      "users_password": password.text,
    });

    final respone = await http.post(url, headers: headers, body: body);
    if (respone.statusCode == 200) {
      final data = jsonDecode(respone.body);
      print(data['data']['users_id']);
      WellcomeDialog(data['data']['users_id']);
    } else if (respone.statusCode == 404 || respone.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }

  Future<dynamic> WellcomeDialog(int id) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'เข้าสู่ระบบสำเร็จ',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Text(
            'ยินดีต้อนรับเข้าสู่แอปของเรา',
            style: TextStyle(fontFamily: "Itim"),
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

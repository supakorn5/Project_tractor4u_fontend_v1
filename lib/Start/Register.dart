import 'dart:ffi';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/widget/selectimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Register_page extends StatefulWidget {
  const Register_page({super.key});

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {
  final TextEditingController users = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();

  Uint8List? _img;
  final _formKey = GlobalKey<FormState>();
  void selectImage() async {
    try {
      Uint8List img = await pickImage(ImageSource.gallery);
      setState(() {
        _img = img;
      });
    } catch (e) {
      _AlertImage(context);
    }
  }

  var _imgbase64;
  String _getImageBase64(Uint8List img) {
    var _base64 = base64Encode(img);
    return _base64;
  }

  void _AlertImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'แจ้งเตือน !!!',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'เลือกรูปภาพจากในคลังเท่านั้น !!!',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _AlertNoImg(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'แจ้งเตือน !!!',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ไม่มีรูปภาพ !!!',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _AlertCheckBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'แจ้งเตือน !!!',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'กรุณากรอกข้อมูลให้ครบ !!!',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
          ],
        );
      },
    );
  }

  void _AlertResgisterComplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'สมัครสำเร็จเสร็จสิ้น',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ขอบคุณที่มาเข้าร่วมกับ ขอบคุณครับ/ค่ะ',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Login_Page(),
                      ));
                } catch (e) {}
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 58, 16, 0),
                  child: Text(
                    "สมัครสมาชิก",
                    style: TextStyle(
                        fontFamily: "Itim",
                        fontSize: 50,
                        color: Color.fromARGB(255, 246, 177, 122)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Stack(
                    children: [
                      _img != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: MemoryImage(_img!),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  AssetImage("assets/image/user.png"),
                            ),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.add_a_photo,
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      controller: users,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        labelText: "ชื่อผู้ใช้",
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      controller: password,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        labelText: "รหัสผ่าน",
                        labelStyle: TextStyle(
                          fontFamily: "Itim",
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.unlockKeyhole,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกรหัสผ่าน";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      controller: phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        labelText: "เบอร์โทรศัพท์",
                        labelStyle: TextStyle(
                          fontFamily: "Itim",
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        String pattern = r'^(0[689]\d{8}|0\d{1,2}\d{6,7})$';
                        RegExp regex = RegExp(pattern);
                        if (value == null || value.isEmpty) {
                          return "กรุณาเบอร์โทรศัพท์";
                        } else if (!regex.hasMatch(value)) {
                          return 'ตรวจสอบหมายเลขโทรศัพท์ของคุณ';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: SizedBox(
                    width: 300,
                    height: 100,
                    child: TextFormField(
                      controller: address,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        labelText: "ที่อยู่",
                        labelStyle: TextStyle(
                          fontFamily: "Itim",
                          color: Colors.black,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.mapLocationDot,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกที่อยู่";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 246, 177, 122)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            try {
                              _imgbase64 = _getImageBase64(_img!);
                              _AlertResgisterComplete(context);
                            } catch (e) {
                              _AlertNoImg(context);
                            }
                          } else {
                            _AlertCheckBox(context);
                          }
                        },
                        child: const Text(
                          "สมัครสมาชิก",
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
    );
  }
}

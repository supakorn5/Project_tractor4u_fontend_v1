import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/widget/selectimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget {
  final int? id;
  const EditProfile({super.key, this.id});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  int? ID;
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ID = widget.id;
  }

  Uint8List? _img;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "แก้ไขข้อมูลส่วนตัว",
            style: TextStyle(fontFamily: "Itim"),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _AlertDelete(context);
                },
                icon: const Icon(Icons.delete))
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
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
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  //   child: SizedBox(
                  //     width: 300,
                  //     height: 100,
                  //     child: TextFormField(
                  //       controller: users,
                  //       decoration: const InputDecoration(
                  //         border: OutlineInputBorder(
                  //             borderRadius:
                  //                 BorderRadius.all(Radius.circular(16))),
                  //         labelText: "ชื่อผู้ใช้",
                  //         labelStyle: TextStyle(
                  //           fontFamily: "Itim",
                  //           color: Colors.black,
                  //         ),
                  //         prefixIcon: Icon(
                  //           Icons.person,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       validator: (value) {
                  //         String pattern = r'^[a-zA-Z0-9]{0,500}$';
                  //         RegExp regex = RegExp(pattern);
                  //         if (value == null || value.isEmpty) {
                  //           return "กรุณากรอกชื่อผู้ใช้";
                  //         } else if (!regex.hasMatch(value)) {
                  //           return 'ตรวจสอบชื่อผู้ใช้ของคุณว่ามี อักขระพิเศษ';
                  //         }
                  //         return null;
                  //       },
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 246, 177, 122)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  _imgbase64 = _getImageBase64(_img!);
                                  UpdateProfile(
                                      password, phone, _imgbase64, ID!);
                                  _AlertUpdateComplete(context);
                                } catch (e) {
                                  _AlertNoImg(context);
                                }
                              } else {
                                _AlertCheckBox(context);
                              }
                            },
                            child: const Text(
                              "ยืนยัน",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Itim",
                                  color: Colors.black),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  void _AlertDelete(BuildContext context) {
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
                'ทำต้องการลบบัญชีของท่าน ใช่ หรือ ไม่!!!',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 238, 149, 149) // Set the width and height
                      ),
                  onPressed: () {
                    // Perform some action
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Login_Page(),
                    ));
                  },
                  child: const Text(
                    'ใช่',
                    style: TextStyle(fontFamily: "Itim", color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                          255, 224, 251, 226) // Set the width and height
                      ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'ไม่',
                    style: TextStyle(fontFamily: "Itim", color: Colors.black),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _AlertUpdateComplete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'แก้ไขเสร็จสิ้น',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'แก้ไขข้อมูลสำเร็จ',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                try {
                  Navigator.of(context).pop();
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

  Future<void> UpdateProfile(TextEditingController password,
      TextEditingController phone, String img, int _ID) async {
    final url = Uri.parse(
        "http://192.168.165.188:5000/api/users/updataProfile/${_ID}"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "users_password": password.text,
      "users_phone": phone.text,
      "users_image": img.toString(),
    });

    final respone = await http.put(url, headers: headers, body: body);
    if (respone.statusCode == 200) {
      final data = jsonDecode(respone.body);
      print(data['message']);
    } else {
      final data = jsonDecode(respone.body);
      print(data['message']);
    }
  }
}

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController users = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController phone = TextEditingController();
  late int GroupValue = 0;

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

  void _AlertImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'แจ้งเตือน !!!',
            style: TextStyle(fontFamily: "Prompt"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'กรุณาเลือกรูปภาพ !!!',
                style: TextStyle(fontFamily: "Prompt"),
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
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Prompt"),
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
            style: TextStyle(fontFamily: "Prompt"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ไม่มีรูปภาพ !!!',
                style: TextStyle(fontFamily: "Prompt"),
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
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Prompt"),
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
            style: TextStyle(fontFamily: "Prompt"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'กรุณาตรวจสอบข้อมูลของคุณ !!!',
                style: TextStyle(fontFamily: "Prompt"),
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
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Navigator.of(context).pop();
              },
              child: const Text(
                'ตกลง',
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _Register(
      TextEditingController users,
      TextEditingController password,
      TextEditingController phone,
      int userType,
      String img) async {
    final url = Uri.parse(
        "http://192.168.96.151:5000/api/users/register_users"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "users_username": users.text,
      "users_password": password.text,
      "users_phone": phone.text,
      "users_type": userType.toInt(),
      "users_image": img.toString(),
    });

    final respone = await http.post(url, headers: headers, body: body);
    if (respone.statusCode == 200) {
      final data = jsonDecode(respone.body);
      print(data['message']);
    } else {
      final data = jsonDecode(respone.body);
      print(data['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                                fontFamily: "Prompt",
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
                          child: Column(
                            children: [
                              SizedBox(
                                width: 300,
                                height: 100,
                                child: TextFormField(
                                  controller: users,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    labelText: "ชื่อผู้ใช้",
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
                                      return 'ตรวจสอบชื่อผู้ใช้ของคุณ';
                                    } else if (RegExp(r'[ก-๙]')
                                        .hasMatch(value)) {
                                      return 'ชื่อผู้ใช้ห้ามมีตัวอักษรภาษาไทย';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                height: 100,
                                child: TextFormField(
                                  controller: password,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    labelText: "รหัสผ่าน",
                                    labelStyle: TextStyle(
                                      fontFamily: "Prompt",
                                      color: Colors.black,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "กรุณากรอกรหัสผ่าน";
                                    } else if (value.length < 6) {
                                      return "รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร";
                                    } else if (RegExp(r'[ก-๙]')
                                        .hasMatch(value)) {
                                      return 'ชื่อผู้ใช้ห้ามมีตัวอักษรภาษาไทย';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 300,
                                height: 100,
                                child: TextFormField(
                                  controller: phone,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16))),
                                    labelText: "เบอร์โทรศัพท์",
                                    labelStyle: TextStyle(
                                      fontFamily: "Prompt",
                                      color: Colors.black,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.black,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    String pattern = r'^\d{10}$';
                                    RegExp regex = RegExp(pattern);
                                    if (value == null || value.isEmpty) {
                                      return "กรุณากรอกเบอร์โทรศัพท์";
                                    } else if (!regex.hasMatch(value)) {
                                      return "เบอร์โทรศัพท์ไม่ถูกต้อง";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                        value: 0,
                                        groupValue: GroupValue,
                                        onChanged: (value) {
                                          setState(() {
                                            print(value);
                                            GroupValue = value as int;
                                          });
                                        },
                                      ),
                                      const Text(
                                        "เกษตรกร",
                                        style: TextStyle(
                                            fontFamily: "Prompt",
                                            fontSize: 20,
                                            color: Colors.black),
                                      ),
                                      Radio(
                                        value: 1,
                                        groupValue: GroupValue,
                                        onChanged: (value) {
                                          print(value);
                                          setState(() {
                                            GroupValue = value as int;
                                          });
                                        },
                                      ),
                                      const Text(
                                        "เจ้าของรถไถ",
                                        style: TextStyle(
                                            fontFamily: "Prompt",
                                            fontSize: 20,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await _Register(users, password, phone,
                                            GroupValue, _getImageBase64(_img!));
                                      } catch (e) {
                                        _AlertNoImg(context);
                                      }
                                    } else {
                                      _AlertCheckBox(context);
                                    }
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color.fromARGB(255, 246, 177, 122)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Color.fromARGB(
                                              255, 246, 177, 122)),
                                    )),
                                  ),
                                  child: const Text(
                                    "ลงทะเบียน",
                                    style: TextStyle(
                                      fontFamily: "Prompt",
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              ),
            )));
  }
}

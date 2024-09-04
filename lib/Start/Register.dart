import 'dart:developer';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Ipglobals.dart';
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
  final TextEditingController usersController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController tellController = TextEditingController();
  String? _selectedItem;
  final List<String> _items = ['เกษตกร', 'เจ้าของรถไถ'];
  int types = 0;

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
                Get.back();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Get.back();
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
                Get.back();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Get.back();
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
                Get.back();
              },
              child: const Text(
                'ยกเลิก',
                style: TextStyle(fontFamily: "Prompt"),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform some action
                Get.back();
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
        "http://${IPGlobals}:5000/api/users/register_users"); // Replace with your machine's IP address
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            Container(
              height: MediaQuery.sizeOf(context).height * 0.22,
              child: Stack(
                children: [
                  Positioned(
                      child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/image/register.png"),
                            fit: BoxFit.fill)),
                  )),
                ],
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
                          backgroundImage: AssetImage("assets/image/user.png"),
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
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "สมัครสมาชิก",
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
                controller: passwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.lock),
                    prefixIconColor: Colors.black,
                    labelText: "รหัสผ่าน",
                    labelStyle: TextStyle(fontFamily: "Prompt"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณากรอกรหัสผ่าน";
                  }
                  if (RegExp(r'[ก-๙]').hasMatch(value)) {
                    return 'ชื่อรหัสผ่านห้ามมีตัวอักษรภาษาไทย';
                  }
                  if (value.length < 6) {
                    return "รหัสผ่านต้องยาวมากกว่า 6 ตัว";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextFormField(
                controller: tellController,
                decoration: InputDecoration(
                  prefixIcon: Icon(FontAwesomeIcons.phone),
                  prefixIconColor: Colors.black,
                  labelText: "เบอร์โทรศัพท์",
                  labelStyle: TextStyle(fontFamily: "Prompt"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณากรอกเบอร์โทรศัพท์";
                  }
                  if (RegExp(r'[ก-๙]').hasMatch(value)) {
                    return 'ชื่อผู้ใช้ห้ามมีตัวอักษรภาษาไทย';
                  }
                  if (!RegExp(r'^0[0-9]{9}$').hasMatch(value)) {
                    return 'กรุณากรอกเบอร์โทรศัพท์ที่ถูกต้อง (10 หลัก)';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: DropdownButtonFormField<String>(
                value: _selectedItem,
                hint: Text(
                  'เลือกประเภทผู้ใช้งาน',
                  style: TextStyle(fontFamily: "Prompt"),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                    if (_selectedItem == "เกษตกร") {
                      types = 0;
                    } else if (_selectedItem == "เจ้าของรถไถ") {
                      types = 1;
                    }
                    log("ประเภทผู้ใช้งาน : ${_selectedItem}");
                    log("types : ${types}");
                  });
                },
                items: _items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontFamily: "Prompt"),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: "ตัวเลือก",
                    labelStyle: TextStyle(fontFamily: "Prompt")),
                validator: (value) {
                  if (value == null) {}
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
                    if (_img == null) {
                      Get.snackbar("แจ้งเตือน", "เลือกรูปภาพของคุณ");
                    } else if (_selectedItem == null) {
                      Get.snackbar("แจ้งเตือน", "กรุณาเลือกประเภทผู้ใช้งาน");
                    } else {
                      await _Register(usersController, passwordController,
                          tellController, types, _getImageBase64(_img!));
                      Get.snackbar("แจ้งเตือน", "สมัครสมาชิกสำเร็จ");
                      Get.off(() => Login_Page());
                    }
                  } else {
                    Get.snackbar("แจ้งเตือน", "โปรดตรวจสอบข้อมูลของคุณ");
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        "สมัครสมาชิก",
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
                  "คุณเป็นสมาชิกแล้ว?",
                  style: TextStyle(fontFamily: "Prompt"),
                ),
                TextButton(
                    onPressed: () {
                      Get.to(() => Login_Page());
                    },
                    child: Text(
                      "เข้าสู่ระบบ",
                      style:
                          TextStyle(fontFamily: "Prompt", color: Colors.blue),
                    ))
              ],
            )
          ]),
        ),
      ),
    ));
  }
}

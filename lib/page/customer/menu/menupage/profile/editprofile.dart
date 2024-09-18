import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Ipglobals.dart';
import 'package:tractor4your/model/users/getuserbyid.dart';
import 'package:tractor4your/service/users/ProfileService.dart';
import 'package:tractor4your/widget/ProfileWidget.dart';
import 'package:tractor4your/widget/Profile_addAdress_user.dart';
import 'package:tractor4your/widget/changeTellnumber.dart';
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
  late Future<Getuserbyid> futureUsers;
  Uint8List? _img;

  @override
  void initState() {
    super.initState();
    futureUsers =
        ProfileService().getUsersById(widget.id!); // Initialize futureUsers
  }

  String _getImageBase64(Uint8List img) {
    return base64Encode(img);
  }

  Future<void> updataProfilePic(String Img) async {
    if (Img.isEmpty) {
      log("Image data is empty");
      return;
    }

    final url =
        Uri.parse("http://${IPGlobals}:5000/api/users/updateProfilePic");
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"users_image": Img, "user_id": widget.id});

    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("${data}");
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }

  Future<void> selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.gallery);
      if (img == null) {
        print("No image selected");
        return;
      }

      _img = img;
      if (_img != null) {
        await updataProfilePic(_getImageBase64(_img!));
        setState(() {
          futureUsers = ProfileService().getUsersById(widget.id!);
        });
      }
    } catch (e) {
      log("Error selecting image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(a, r, g, b),
        title: const Text(
          "แก้ไขข้อมูลส่วนตัว",
          style: TextStyle(fontFamily: "Prompt"),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back(result: 1);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => EditProfile(id: widget.id!));
            },
            icon: const Icon(LineAwesomeIcons.trash_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: FutureBuilder<Getuserbyid>(
                          future: futureUsers,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.success == false ||
                                snapshot.data!.data!.isEmpty) {
                              return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: []);
                            } else {
                              final users = snapshot.data!.data;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  final user = users[index];
                                  return Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 20, 16, 0),
                                          child: Stack(
                                            children: [
                                              user.usersImage != null
                                                  ? CircleAvatar(
                                                      radius: 50,
                                                      backgroundImage:
                                                          MemoryImage(
                                                              base64Decode(user
                                                                  .usersImage!)),
                                                    )
                                                  : Container(),
                                              Positioned(
                                                bottom: -10,
                                                right: -10,
                                                child: IconButton(
                                                  onPressed: () {
                                                    selectImage();
                                                  },
                                                  icon: const Icon(
                                                      Icons.add_a_photo),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(a, r, g, b)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: ProfileWidget(
                                                  title:
                                                      "ชื่อผู้ใช้งาน : ${user.usersUsername}",
                                                  onPress: () {
                                                    // log("Profile");
                                                    //log("${base64Encode(_img!)}");
                                                  },
                                                  endIcon: false,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: ProfileWidget(
                                                  title: user.usersType == 1
                                                      ? "ประเภทผู้ใช้งาน : เจ้าของรถไถ"
                                                      : "ประเภทผู้ใช้งาน : ลูกค้า",
                                                  onPress: () {},
                                                  endIcon: false,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: ProfileWidget(
                                                  title:
                                                      "เบอร์โทรศัพท์ : ${user.usersPhone}",
                                                  onPress: () async {
                                                    final update =
                                                        await Get.dialog(
                                                            changeTellNum(
                                                      id: widget.id,
                                                    ));
                                                    if (update == 1) {
                                                      setState(() {
                                                        log("${update}");
                                                        futureUsers =
                                                            ProfileService()
                                                                .getUsersById(
                                                                    widget.id!);
                                                      });
                                                      Get.snackbar("แจ้งเตือน",
                                                          "เปลี่ยนเบอร์โทรศัพท์");
                                                    }
                                                  },
                                                  endIcon: true,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 16),
                                                child: ProfileWidget(
                                                  title: user.usersAddress !=
                                                          null
                                                      ? "ที่อยู่ : " +
                                                          user.usersAddress!
                                                      : "กดที่ปุ่มเพื่อเพิ่มข้อมูล",
                                                  onPress: () async {
                                                    final update =
                                                        await Get.dialog(
                                                            ProfilAddAddressUser(
                                                      userID: widget.id,
                                                    ));
                                                    if (update == 1) {
                                                      setState(() {
                                                        futureUsers =
                                                            ProfileService()
                                                                .getUsersById(
                                                                    widget.id!);
                                                        Get.snackbar(
                                                            "แจ้งเตือน",
                                                            "กรอกข้อมูลที่อยู่สำเร็จ");
                                                      });
                                                    }
                                                  },
                                                  endIcon: true,
                                                  textColor: Colors.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

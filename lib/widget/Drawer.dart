import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/model/users/getuserbyid.dart';
import 'package:tractor4your/service/users/ProfileService.dart';
import 'package:lottie/lottie.dart';

class DrawerBarCustom extends StatefulWidget {
  final int? id;
  DrawerBarCustom({super.key, this.id});

  @override
  State<DrawerBarCustom> createState() => _DrawerBarCustomState();
}

class _DrawerBarCustomState extends State<DrawerBarCustom> {
  late Future<Getuserbyid> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = ProfileService().getUsersById(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Getuserbyid>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                  "assets/animation/Animation - 1723570737186.json"),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data == null) {
            return Center(child: Text("No user data available"));
          }

          final userDataList = snapshot.data!.data; // This is a List<Datum>

          return SingleChildScrollView(
            child: Column(
              children: userDataList.map((userData) {
                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        "ชื่อผู้ใช้งาน : ${userData.usersUsername}",
                        style: TextStyle(fontFamily: "Prompt", fontSize: 20),
                      ),
                      accountEmail: userData.usersAddress == null
                          ? Text(
                              "ที่อยู่ : ยังไม่มีข้อมูลที่อยู่",
                              style:
                                  TextStyle(fontFamily: "Prompt", fontSize: 10),
                            )
                          : Text(
                              "ที่อยู่ : ${userData.usersAddress}",
                              style:
                                  TextStyle(fontFamily: "Prompt", fontSize: 10),
                            ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: userData.usersImage != null
                            ? MemoryImage(base64Decode(userData.usersImage))
                            : AssetImage('assets/image/default_profile.png')
                                as ImageProvider, // or NetworkImage if you prefer
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/image/userBackground.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        FontAwesomeIcons.user,
                        size: 20,
                        color: Colors.black,
                      ),
                      title: Text(
                        'โปรไฟล์',
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.access_time,
                        color: Colors.black,
                      ),
                      title: Text(
                        'จองคิว',
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.timelapse,
                        color: Colors.black,
                      ),
                      title: Text(
                        'สถานะการทำงาน',
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Colors.black,
                      ),
                      title: Text(
                        'ประวัติการจอง',
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      title: Text(
                        'ออกจากระบบ',
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                      onTap: () {
                        Get.offUntil(
                            MaterialPageRoute(
                              builder: (context) => Login_Page(),
                            ),
                            (route) => false);
                      },
                    ),
                  ],
                );
              }).toList(), // Mapping over the List<Datum>
            ),
          );
        },
      ),
    );
  }
}

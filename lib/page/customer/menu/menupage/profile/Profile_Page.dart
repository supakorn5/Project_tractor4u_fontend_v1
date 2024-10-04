import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/model/users/getuserbyid.dart';
import 'package:tractor4your/page/customer/menu/menupage/profile/editprofile.dart';
import 'package:tractor4your/service/lands/LandService.dart';
import 'package:tractor4your/service/users/ProfileService.dart';

class Profile_Page extends StatefulWidget {
  final int? id;
  Profile_Page({super.key, this.id});

  @override
  State<Profile_Page> createState() => _Profile_PageState();
}

class _Profile_PageState extends State<Profile_Page> {
  late Future<Getuserbyid> futureUsers;
  Uint8List? _img;

  @override
  void initState() {
    super.initState();
    futureUsers = ProfileService().getUsersById(widget.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back(result: 1);
              },
              icon: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            "ข้อมูลส่วนตัว",
            style: TextStyle(fontFamily: "Prompt", color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(a, r, g, b),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<Getuserbyid>(
              future: futureUsers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                  return Stack(
                    children: [
                      Container(
                          height: 240,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60.0),
                              bottomRight: Radius.circular(60.0),
                            ),
                            color: Color.fromARGB(a, r, g, b),
                          )),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: users.isNotEmpty
                                ? MemoryImage(
                                    base64Decode(users[0].usersImage!))
                                : AssetImage('assets/icon/user.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 150),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${users[0].usersUsername}",
                                style: TextStyle(
                                    fontFamily: "Prompt", fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    final update =
                                        await Get.to(() => EditProfile(
                                              id: widget.id,
                                            ));
                                    if (update == 1) {
                                      log("${update}");
                                      setState(() {
                                        futureUsers = ProfileService()
                                            .getUsersById(widget.id!);
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    LineAwesomeIcons.user_edit_solid,
                                    color: Colors.black,
                                  )),
                            ],
                          )),
                      Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 80.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 5),
                                          color:
                                              Color.fromARGB(96, 141, 139, 139),
                                          blurRadius: 5),
                                    ],
                                  )),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(top: 225),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              users[0].usersType == 1
                                  ? Text(
                                      "ประเภทผู้ใช้ : ลูกค้า",
                                      style: TextStyle(
                                          fontFamily: "Prompt", fontSize: 20),
                                    )
                                  : Text(
                                      "ประเภทผู้ใช้ : เจ้าของรถไถ",
                                      style: TextStyle(
                                          fontFamily: "Prompt", fontSize: 20),
                                    ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 290),
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.8, // Make sure width is constrained
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(a, r, g, b),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: ListTile(
                                          horizontalTitleGap: 20,
                                          leading: Icon(
                                            Icons.location_history,
                                            color: Colors.black,
                                            size: 50,
                                          ),
                                          title: Text(
                                            "ที่อยู่",
                                            style:
                                                TextStyle(fontFamily: "Prompt"),
                                          ),
                                          subtitle:
                                              users[0].usersAddress != null
                                                  ? Text(
                                                      "${users[0].usersAddress}",
                                                      style: TextStyle(
                                                          fontFamily: "Prompt",
                                                          color: Colors.black),
                                                    )
                                                  : Text(
                                                      "ยังไม่มีข้อมูล",
                                                      style: TextStyle(
                                                          fontFamily: "Prompt",
                                                          color: Colors.black),
                                                    )),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(a, r, g, b),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: ListTile(
                                          horizontalTitleGap: 20,
                                          leading: Icon(
                                            LineAwesomeIcons
                                                .map_marked_alt_solid,
                                            color: Colors.black,
                                            size: 50,
                                          ),
                                          title: Text(
                                            "ตำแหน่งบนแผนที่",
                                            style:
                                                TextStyle(fontFamily: "Prompt"),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  users[0].usersLat != null
                                                      ? Text(
                                                          "LAT : ${users[0].usersLat}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Prompt",
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      : Text(
                                                          "LAT : ยังไม่มีข้อมูล",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Prompt",
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  users[0].usersLon != null
                                                      ? Text(
                                                          "LON : ${users[0].usersLon}",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Prompt",
                                                              color:
                                                                  Colors.black),
                                                        )
                                                      : Text(
                                                          "LON : ยังไม่มีข้อมูล",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  "Prompt",
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(a, r, g, b),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomRight:
                                                  Radius.circular(20))),
                                      child: ListTile(
                                          horizontalTitleGap: 20,
                                          leading: Icon(
                                            LineAwesomeIcons.phone_square_solid,
                                            color: Colors.black,
                                            size: 50,
                                          ),
                                          title: Text(
                                            "เบอร์โทรศัพท์",
                                            style:
                                                TextStyle(fontFamily: "Prompt"),
                                          ),
                                          subtitle: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "เบอร์  : ${users[0].usersPhone}",
                                                    style: TextStyle(
                                                        fontFamily: "Prompt"),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),
        ));
  }
}

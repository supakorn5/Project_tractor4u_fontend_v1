import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tractor4your/model/users/getuserbyid.dart'; // Correct import path
import 'package:tractor4your/page/customer/menu/menupage/profile/editprofile.dart';
import 'package:tractor4your/service/users/ProfileService.dart';

class Profile extends StatefulWidget {
  final int? id;
  const Profile({super.key, this.id});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Getuserbyid> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers =
        ProfileService().getUsersById(widget.id!); // Initialize futureUsers
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 177, 122),
        title: const Text(
          "ข้อมูลส่วนตัว",
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditProfile(id: widget.id!),
                ));
              },
              icon: const Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      // Ensure the ListView has constraints
                      child: FutureBuilder<Getuserbyid>(
                        future: futureUsers,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.success == false ||
                              snapshot.data!.data!.isEmpty) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
                            );
                          } else {
                            final users = snapshot.data!.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return Center(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 65,
                                            backgroundImage: MemoryImage(
                                              base64Decode(user.usersImage!),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${user.usersUsername}",
                                              style: const TextStyle(
                                                  fontFamily: "Bebas",
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 15),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 300,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(16)),
                                                color: Color.fromARGB(
                                                    255, 246, 177, 122),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${user.usersPhone}",
                                                      style: const TextStyle(
                                                          fontFamily: "Itim",
                                                          fontSize: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 50,
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(16)),
                                              color: Color.fromARGB(
                                                  255, 246, 177, 122),
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "กดเพื่อเพิ่มที่อยู่",
                                                    style: TextStyle(
                                                        fontFamily: "Itim",
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
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
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

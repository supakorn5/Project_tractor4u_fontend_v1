import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/model/orders/getownerID.dart';
import 'package:tractor4your/page/Owner/menu/JOB/job.dart';
import 'package:tractor4your/service/orders/OderService.dart';
import 'package:lottie/lottie.dart';
import '../../../widget/Drawer.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class Owner_mainMenu extends StatefulWidget {
  final int? id;
  Owner_mainMenu({super.key, this.id});

  @override
  State<Owner_mainMenu> createState() => _Owner_mainMenuState();
}

class _Owner_mainMenuState extends State<Owner_mainMenu> {
  late Future<GetOwnerId> futureOwnerID;
  int? owner_ID;

  @override
  void initState() {
    super.initState();
    log("${widget.id}");
    // Initialize futureOwnerID with a default value
    owner_ID = widget.id;
    futureOwnerID = Future.value(GetOwnerId());
    if (widget.id != null) {
      futureOwnerID = OrderService().fetchOwnerID(owner_ID!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            drawer: DrawerBarCustom(id: widget.id),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Color.fromARGB(a, r, g, b),
              title: const Text(
                "หน้าหลัก",
                style: TextStyle(fontFamily: "Prompt"),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  FutureBuilder(
                      future: futureOwnerID,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Handle loading state
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final userData = snapshot.data!.data!;
                          return SizedBox(
                            // Add height constraint
                            height: 150, // or any height you prefer
                            child: ListView.builder(
                              itemCount: userData.length,
                              itemBuilder: (context, index) {
                                final data = userData[index];
                                return Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: AnotherCarousel(
                                    images: [
                                      GestureDetector(
                                        child: Image.asset(
                                          "assets/image/reservePoster.png",
                                          fit: BoxFit.cover,
                                        ),
                                        onTap: () {
                                          Get.to(() => Job(
                                                id: data.ownersId,
                                              ));
                                          log("รับงาน");
                                        },
                                      ),
                                      GestureDetector(
                                        child: Image.asset(
                                          "assets/image/statusPoster.png",
                                          fit: BoxFit.cover,
                                        ),
                                        onTap: () {
                                          log("สถานะการทำงาน");
                                        },
                                      ),
                                      GestureDetector(
                                        child: Image.asset(
                                          "assets/image/historyPoster.png",
                                          fit: BoxFit.cover,
                                        ),
                                        onTap: () {
                                          log("ประวัติ");
                                        },
                                      ),
                                    ],
                                    dotSize: 3,
                                    boxFit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      log("");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Colors.grey,
                            offset: Offset(4, 5),
                          ),
                        ],
                      ),
                      height: 100,
                      width: MediaQuery.sizeOf(context).width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            20), // Match with container's borderRadius
                        child: Image.asset(
                          "assets/image/reserve.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Colors.grey,
                            offset: Offset(4, 5),
                          ),
                        ],
                      ),
                      height: 100,
                      width: MediaQuery.sizeOf(context).width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            20), // Match with container's borderRadius
                        child: Image.asset(
                          "assets/image/status.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 1,
                            color: Colors.grey,
                            offset: Offset(4, 5),
                          ),
                        ],
                      ),
                      height: 100,
                      width: MediaQuery.sizeOf(context).width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            20), // Match with container's borderRadius
                        child: Image.asset(
                          "assets/image/history.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            )));
  }
}

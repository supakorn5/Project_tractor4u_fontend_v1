import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/model/orders/getownerID.dart';
import 'package:tractor4your/page/Owner/menu/JOB/job.dart';
import 'package:tractor4your/page/Owner/menu/workStatus/workStatus.dart';
import 'package:tractor4your/service/orders/OderService.dart';
import 'package:lottie/lottie.dart';
import '../../../widget/Drawer.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class Owner_mainMenu extends StatefulWidget {
  final int? id;
  final int? type;
  Owner_mainMenu({super.key, this.id, this.type});

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
    log("${widget.type}");
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
            drawer: DrawerBarCustom(
              id: widget.id,
              type: widget.type,
            ),
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
                  child: FutureBuilder(
                    future: futureOwnerID,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("ERROR : ${snapshot.error}");
                      }
                      final ownerData = snapshot.data!.data;
                      return Column(children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          child: AnotherCarousel(
                            images: [
                              GestureDetector(
                                child: Image.asset(
                                  "assets/image/reservePoster.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GestureDetector(
                                child: Image.asset(
                                  "assets/image/statusPoster.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GestureDetector(
                                child: Image.asset(
                                  "assets/image/historyPoster.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                            dotSize: 3,
                            boxFit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => Job(
                                  id: ownerData?[0].ownersId,
                                ));
                            log("${ownerData?[0].ownersId}");
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
                        GestureDetector(
                          onTap: () => Get.to(() => workStatus()),
                          child: Padding(
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
                      ]);
                    },
                  )),
            )));
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/page/customer/menu/menupage/selectOwnerList.dart';
import '../../../widget/Drawer.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class customerMenupage extends StatefulWidget {
  final int? id;
  final int? lands_id;
  customerMenupage({super.key, this.id, this.lands_id});

  @override
  State<customerMenupage> createState() => _customerMenupageState();
}

class _customerMenupageState extends State<customerMenupage> {
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
                          onTap: () {
                            log("จองคิว");
                            Get.off(() => SelectOwnerList(
                                users_id: widget.id,
                                lands_id: widget.lands_id));
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
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      log("จองคิว");
                      Get.off(() => SelectOwnerList(
                          users_id: widget.id, lands_id: widget.lands_id));
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

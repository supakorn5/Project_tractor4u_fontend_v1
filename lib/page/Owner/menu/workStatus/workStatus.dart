import "dart:developer";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:line_awesome_flutter/line_awesome_flutter.dart";
import "package:tractor4your/CodeColorscustom.dart";
import "package:tractor4your/page/Owner/menu/History/history.dart";

class workStatus extends StatefulWidget {
  const workStatus({super.key});

  @override
  State<workStatus> createState() => _workStatusState();
}

class _workStatusState extends State<workStatus> {
  Color _buidColor(int index) {
    Color c;
    switch (index) {
      case 0:
        c = Colors.greenAccent;
        break;
      case 1:
        c = Colors.amberAccent;
        break;
      case 2:
        c = Colors.redAccent;
        break;
      default:
        c = Colors.grey;
    }
    return c;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(a, r, g, b),
          title: const Text(
            "การทำงาน",
            style: TextStyle(fontFamily: "Prompt"),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
              onPressed: () => Get.to(() => History()),
              icon: Icon(LineAwesomeIcons.history_solid),
              color: Colors.black,
            )
          ],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          bottom: TabBar(
              labelStyle: TextStyle(fontFamily: "Prompt", color: Colors.black),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Text(
                    "รอทำงาน",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "รอการชำระเงิน",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      color: Colors.black,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "เสร็จสิ้น",
                    style: TextStyle(
                      fontFamily: "Prompt",
                      color: Colors.black,
                    ),
                  ),
                ),
              ]),
        ),
        body: TabBarView(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  height: 100,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                      color: _buidColor(0),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "ชื่อลูกค้า : ",
                                  style: TextStyle(
                                      fontFamily: "Prompt", fontSize: 15),
                                ),
                                Text(
                                  "วันที่เริ่มทำงาน : ",
                                  style: TextStyle(
                                      fontFamily: "Prompt", fontSize: 15),
                                ),
                                Text(
                                  "ขนาดของงาน : ",
                                  style: TextStyle(
                                      fontFamily: "Prompt", fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            child: Text("2"),
          ),
          Container(
            child: Text("3"),
          ),
        ]),
      ),
    ));
  }
}

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tractor4your/model/lands/getlandsnotreserve.dart';
import 'package:tractor4your/page/customer/menu/menubottombar.dart';
import 'package:tractor4your/page/customer/workplace/addworkplace.dart';
import 'package:tractor4your/service/orders/OderService.dart';
import '../../../service/lands/LandService.dart';
import '../../../model/lands/getlandsbyuser_id.dart';
import 'package:lottie/lottie.dart';

class Workplace extends StatefulWidget {
  final int? id;
  const Workplace({Key? key, this.id}) : super(key: key);

  @override
  State<Workplace> createState() => _WorkplaceState();
}

class _WorkplaceState extends State<Workplace> {
  late Future<GetLandsByUserid> futureLands;
  late Future<GetLandNotReserve> futureLandsNotReserve;
  List<String> Date = [];
  List<String> DateSplite = [];
  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      print('Error: Widget ID is null');
      futureLands = Future.error('Widget ID is null');
    } else {
      futureLands = LandService().fetchLand(widget.id!);
      futureLandsNotReserve = LandService().fetchLandNotReserve(widget.id!);
    }
  }

  List<String> Status = [
    "รอรับคิว",
    "รอไถ",
    "กำลังไถ",
    "รอจ่ายตังค์",
    "เสร็จ",
    "ยกเลิก"
  ];

  List<String> Month = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ];

  Color getColorForStatus(int status) {
    switch (status) {
      case 1:
        return Colors.lightGreenAccent.shade100;
      case 2:
        return Colors.lightBlueAccent;
      case 3:
        return Colors.amber.shade600;
      case 4:
        return Colors.amber.shade300;
      case 5:
        return Colors.blue.shade700;
      case 6:
        return Colors.redAccent;
      default:
        return Color.fromARGB(255, 211, 215, 245);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 177, 122),
        title: const Text(
          "เลือกพื้นที่ต้องการไถ",
          style: TextStyle(fontFamily: "Itim"),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.transparent,
          ),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      Addworkplace(id: widget.id, mapdata: const []),
                ),
              );
            },
            icon: const Icon(Icons.add_location_alt_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                  "assets/animation/Animation - 1723570737186.json"),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            "ที่ดินที่ยังไม่ถูกจอง",
                            style: TextStyle(fontFamily: "Itim", fontSize: 20),
                          ),
                        ),
                        Expanded(
                            child: FutureBuilder(
                          future: futureLandsNotReserve,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data == null) {
                              return Center(child: Text("No data available"));
                            }
                            final LandsDataNotReserve = snapshot.data!.data!;
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: LandsDataNotReserve.length,
                              itemBuilder: (context, index) {
                                return Column(children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => MenuBottombar(
                                            id: widget.id,
                                            lands_id: LandsDataNotReserve[index]
                                                .landsId),
                                      ));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: getColorForStatus(7),
                                      ),
                                      padding: EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "ข้อมูลที่ดิน: ${LandsDataNotReserve[index].landsInfo}",
                                                style: TextStyle(
                                                    fontFamily: "Itim",
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "วันที่จอง: - ",
                                                style: TextStyle(
                                                    fontFamily: "Itim",
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "สถานะการทำงาน: - ",
                                                style: TextStyle(
                                                    fontFamily: "Itim",
                                                    fontSize: 15),
                                              ),
                                              Text(
                                                "เจ้าของรถไถที่จอง: - ",
                                                style: TextStyle(
                                                    fontFamily: "Itim",
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  )
                                ]);
                              },
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 50,
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            "ที่ดินที่ถูกจอง",
                            style: TextStyle(fontFamily: "Itim", fontSize: 20),
                          ),
                        ),
                        Expanded(
                          child: FutureBuilder<GetLandsByUserid>(
                            future: futureLands,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text("Error: ${snapshot.error}"),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.data!.isEmpty) {
                                return Center(
                                  child: Text("No land data available"),
                                );
                              } else {
                                final LandsData = snapshot.data!.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: LandsData.length,
                                  itemBuilder: (context, index) {
                                    Date = LandsData[index]
                                        .date
                                        .toString()
                                        .split(' ');
                                    DateSplite = Date[0].split('-');
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  MenuBottombar(
                                                      id: widget.id,
                                                      lands_id: LandsData[index]
                                                          .landsId),
                                            ));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            height: 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: getColorForStatus(
                                                    LandsData[index]
                                                        .ordersStatus!)),
                                            padding: EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "ข้อมูลที่ดิน: ${LandsData[index].landsInfo}",
                                                      style: TextStyle(
                                                          fontFamily: "Itim",
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "วันที่จอง: ${int.parse(DateSplite[2])} ${Month[int.parse(DateSplite[1]) - 1]} ${DateSplite[0]}",
                                                      style: TextStyle(
                                                          fontFamily: "Itim",
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "สถานะการทำงาน: ${Status[LandsData[index].ordersStatus! - 1]}",
                                                      style: TextStyle(
                                                          fontFamily: "Itim",
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "เจ้าของรถไถที่จอง: ${LandsData[index].usersUsername}",
                                                      style: TextStyle(
                                                          fontFamily: "Itim",
                                                          fontSize: 15),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height:
                                                16), // Spacing between items
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}

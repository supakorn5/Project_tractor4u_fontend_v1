import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/model/lands/getlandsnotreserve.dart';
import 'package:tractor4your/page/customer/menu/customerMenuPage.dart';
import 'package:tractor4your/page/customer/workplace/addworkplace.dart';
import '../../../service/lands/LandService.dart';
import '../../../model/lands/getlandsbyuser_id.dart';
import 'package:lottie/lottie.dart';

class Workplace extends StatefulWidget {
  final int? id;
  final int? type;
  const Workplace({Key? key, this.id, this.type}) : super(key: key);

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
        child: DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  backgroundColor: Color.fromARGB(a, r, g, b),
                  title: const Text(
                    "เลือกพื้นที่ต้องการไถ",
                    style: TextStyle(fontFamily: "Prompt"),
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
                        Get.to(() =>
                            Addworkplace(id: widget.id, mapdata: const []));
                      },
                      icon: const Icon(Icons.add_location_alt_rounded),
                    ),
                  ],
                  bottom: TabBar(
                      labelStyle:
                          TextStyle(fontFamily: "Prompt", color: Colors.black),
                      dividerColor: Colors.transparent,
                      tabs: [
                        Tab(
                          text: "ที่ดินที่ยังไม่จอง",
                          style: TextStyle(
                              fontFamily: "Prompt", color: Colors.black),
                        ),
                        Tab(
                            text: "ที่ดินที่จองแล้ว",
                            style: TextStyle(
                                fontFamily: "Prompt", color: Colors.black)),
                      ]),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder(
                    future: Future.delayed(Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Lottie.asset(
                              "assets/animation/Animation - 1723570737186.json"),
                        );
                      }
                      return TabBarView(
                        children: [
                          Container(
                            child: Column(
                              children: [
                                Expanded(
                                  child: FutureBuilder(
                                    future: futureLandsNotReserve,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                "Error: ${snapshot.error}"));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null) {
                                        return Center(
                                            child: Text("No data available"));
                                      }
                                      final LandsDataNotReserve =
                                          snapshot.data!.data!;
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: LandsDataNotReserve.length,
                                        itemBuilder: (context, index) {
                                          return Column(children: [
                                            LandsDataNotReserve.isNotEmpty
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.to(
                                                        () => customerMenupage(
                                                            id: widget.id,
                                                            lands_id:
                                                                LandsDataNotReserve[
                                                                        index]
                                                                    .landsId,
                                                            type: widget.type),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: 120,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color:
                                                            getColorForStatus(
                                                                7),
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(16.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "ข้อมูลที่ดิน: ${LandsDataNotReserve[index].landsInfo}",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Prompt",
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Text(
                                                                "วันที่จอง: - ",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Prompt",
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Text(
                                                                "สถานะการทำงาน: - ",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Prompt",
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              Text(
                                                                "เจ้าของรถไถที่จอง: - ",
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Prompt",
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 16,
                                            )
                                          ]);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Expanded(
                                  child: FutureBuilder<GetLandsByUserid>(
                                    future: futureLands,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                          child:
                                              Text("Error: ${snapshot.error}"),
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
                                                    Get.to(
                                                      () => customerMenupage(
                                                          id: widget.id,
                                                          lands_id:
                                                              LandsData[index]
                                                                  .landsId),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        color: getColorForStatus(
                                                            LandsData[index]
                                                                .ordersStatus!)),
                                                    padding:
                                                        EdgeInsets.all(16.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "ข้อมูลที่ดิน: ${LandsData[index].landsInfo}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Prompt",
                                                                  fontSize: 15),
                                                            ),
                                                            Text(
                                                              "วันที่จอง: ${int.parse(DateSplite[2])} ${Month[int.parse(DateSplite[1]) - 1]} ${DateSplite[0]}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Prompt",
                                                                  fontSize: 15),
                                                            ),
                                                            Text(
                                                              "สถานะการทำงาน: ${Status[LandsData[index].ordersStatus! - 1]}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Prompt",
                                                                  fontSize: 15),
                                                            ),
                                                            Text(
                                                              "เจ้าของรถไถที่จอง: ${LandsData[index].usersUsername}",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Prompt",
                                                                  fontSize: 15),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 16),
                                              ],
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
                      );
                    },
                  ),
                ),
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    // Assuming `land_ID` is selected or predefined, replace `selectedLandId` with the actual value
                    int selectedLandId =
                        0; // Replace with the appropriate logic to get land_ID

                    if (widget.id != null) {
                      Get.off(() => customerMenupage(
                          id: widget.id!, lands_id: selectedLandId));
                    } else {
                      print('Error: ID is null');
                    }
                  },
                  label: const Text(
                    "เลือกภายหลัง",
                    style: TextStyle(fontFamily: "Prompt"),
                  ),
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  backgroundColor: Color.fromARGB(
                      a, r, g, b), // Customize your button's color
                ))));
  }
}

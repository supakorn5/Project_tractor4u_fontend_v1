import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Ipglobals.dart';
import 'package:tractor4your/model/orders/getdatestatus_id.dart';
import 'package:tractor4your/model/orders/getqueuebydate.dart';
import 'package:tractor4your/service/orders/OderService.dart';
import 'package:http/http.dart' as http;

class JobManege extends StatefulWidget {
  final int? id;
  final String? date;
  final VoidCallback? onRefresh; // Callback function

  JobManege({super.key, this.date, this.id, this.onRefresh});

  @override
  State<JobManege> createState() => _JobManegeState();
}

class _JobManegeState extends State<JobManege> {
  List<bool> isExpandedList = [];
  List<String> dateParts = [];
  late String date;
  int? owner_ID;
  late Future<GetDateStatusId> futuredataStatusID;
  late Future<GetQueueByDate> futureQueue;
  int? statusID;
  List<String> Status = [
    "รอรับคิว",
    "อยู่ระหว่างรอดำเนินงาน",
    "กำลังดำเนินงาน",
    "รอชำระ",
    "เสร็จงาน",
    "ยกเลิก"
  ];

  @override
  void initState() {
    super.initState();
    print(widget.id);
    owner_ID = widget.id;
    date = widget.date ?? "default-date"; // Handle null case for date
    dateParts = date.split('-');
    futuredataStatusID =
        OrderService().fetchdateStatusID(widget.date!, widget.id!);
    futureQueue = OrderService().fetchQueue(widget.date!, widget.id!);
  }

  Future<void> _refreshQueue() async {
    setState(() {
      futureQueue = OrderService().fetchQueue(widget.date!, widget.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(a, r, g, b),
          title: const Text(
            "จัดการงาน",
            style: TextStyle(fontFamily: "Prompt"),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back(result: 1);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: FutureBuilder<GetDateStatusId>(
          future: futuredataStatusID,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            } else if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.data == null) {
              return Center(child: Text("No data found"));
            }

            final dateStatusData = snapshot.data!.data!;

            return FutureBuilder<GetQueueByDate>(
              future: futureQueue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.data == null) {
                  return Center(child: Text("No queue data found"));
                }

                final ordersQueue = snapshot.data!.data!;

                if (isExpandedList.isEmpty) {
                  isExpandedList =
                      List.generate(ordersQueue.length, (_) => false);
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "งานของวันที่ ${int.parse(dateParts[2])}",
                                style: TextStyle(
                                    fontFamily: "Prompt", fontSize: 25),
                              ),
                            ],
                          ),
                          Column(
                            children: ordersQueue.map((order) {
                              int index = ordersQueue.indexOf(order);
                              Color backgroundColor;
                              switch (ordersQueue[index].ordersStatus) {
                                case 1:
                                  backgroundColor = Color.fromARGB(a, r, g, b);
                                  break;
                                case 6:
                                  backgroundColor = Colors.red;
                                  break;
                                case 2:
                                  backgroundColor =
                                      Color.fromARGB(255, 161, 233, 161);
                                  break;
                                default:
                                  backgroundColor = Colors.grey;
                              }

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpandedList[index] =
                                        !isExpandedList[index];
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 2,
                                          offset: Offset(4, 5),
                                        ),
                                      ],
                                      color: backgroundColor,
                                    ),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "ลูกค้าที่มาจองคนที่ : ${index + 1}",
                                                style: const TextStyle(
                                                  fontFamily: "Prompt",
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                "ชื่อลูกค้า : ${ordersQueue[index].usersUsername}",
                                                style: TextStyle(
                                                  fontFamily: "Prompt",
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (isExpandedList[index])
                                          AnimatedContainer(
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.easeInOut,
                                            margin: const EdgeInsets.all(8),
                                            width: 300,
                                            height:
                                                150, // You can adjust this height as necessary
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 5,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "รายละเอียดงานเพิ่มเติม",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Prompt",
                                                            fontSize: 18),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "ผู้รับผิดชอบ: ${ordersQueue[index].usersUsername}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Prompt"),
                                                          ),
                                                          Text(
                                                            "พื้นที่: ${ordersQueue[index].landsSizeRai} ไร่",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Prompt"),
                                                          ),
                                                          Text(
                                                            "สถานะ: ${Status[ordersQueue[index].ordersStatus! - 1]}",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Prompt"),
                                                          ),
                                                          ordersQueue[index]
                                                                      .ordersStatus ==
                                                                  1
                                                              ? Row(
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors
                                                                                .red.shade100),
                                                                        onPressed:
                                                                            () {
                                                                          _ConfirmJob(
                                                                              ordersQueue[index].ordersId!,
                                                                              6);
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              FontAwesomeIcons.x,
                                                                              color: Colors.red,
                                                                              size: 15,
                                                                            ),
                                                                            Text(
                                                                              " ไม่รับงาน",
                                                                              style: TextStyle(fontFamily: "Prompt", color: Colors.black),
                                                                            )
                                                                          ],
                                                                        )),
                                                                    SizedBox(
                                                                      width:
                                                                          48.5,
                                                                    ),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor: Colors
                                                                                .green.shade100),
                                                                        onPressed:
                                                                            () {
                                                                          _ConfirmJob(
                                                                              ordersQueue[index].ordersId!,
                                                                              2);
                                                                          _updateDateStatus(
                                                                              2,
                                                                              ordersQueue[index].ordersStatus!);
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              FontAwesomeIcons.check,
                                                                              color: Colors.green,
                                                                              size: 20,
                                                                            ),
                                                                            Text(
                                                                              " รับงาน",
                                                                              style: TextStyle(fontFamily: "Prompt", color: Colors.black),
                                                                            )
                                                                          ],
                                                                        ))
                                                                  ],
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _ConfirmJob(int OrderID, int status) async {
    final url = Uri.parse("http://${IPGlobals}:5000/api/orders/Resever");
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({"orders_id": OrderID, "orders_status": status});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['data']);
      _refreshQueue(); // Refresh the queue after successful status update
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }

  Future<void> _updateDateStatus(int datestatus, int statusID) async {
    final url =
        Uri.parse("http://${IPGlobals}:5000/api/orders/UpdateDateStatus");
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({"datestatus": datestatus, "dateStatus_id": statusID});

    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("COMPLETE");
      print(data['data']);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }

  Future<void> _AlertCloseJob(BuildContext context, int statusID) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '',
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'คุณต้องการปิดรับงานของวันที่นี้หรือไม่',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.xmark,
                      color: Colors.redAccent,
                    ),
                    Text(
                      " ไม่ปิด",
                      style: TextStyle(fontFamily: "Prompt", fontSize: 12),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateDateStatus(3, statusID);
                  Get.back(result: 1);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.check,
                      color: Colors.greenAccent,
                    ),
                    Text(
                      " ปิด",
                      style: TextStyle(fontFamily: "Prompt", fontSize: 12),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        );
      },
    );
  }
}

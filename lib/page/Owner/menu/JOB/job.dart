import 'dart:collection';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tractor4your/model/orders/getdatestatus.dart';
import 'package:tractor4your/model/orders/getordersbyuser_id.dart';
import 'package:tractor4your/page/Owner/menu/JOB/Jobmanage.dart';
import 'package:tractor4your/service/orders/OderService.dart';

class Job extends StatefulWidget {
  final int? id;
  Job({super.key, this.id});

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
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
  late Future<GetDateStatus> futureDateStatus;
  late Future<GetQueueById> futureQueue;

  @override
  void initState() {
    super.initState();
    futureQueue = OrderService().fetchOrders(widget.id!);
    futureDateStatus = OrderService().fetchDatestatus(widget.id!);
  }

  Color getColorForStatus(int status) {
    switch (status) {
      case 1:
        return Color.fromARGB(255, 211, 215, 245); // สีฟ้า
      case 2:
        return Colors.yellow; // สีเหลือง
      default:
        return Color.fromARGB(255, 211, 215, 245);
    }
  }

  Map<String, int> _groupDates(orders) {
    Map<String, int> dateCount = {};
    for (var order in orders) {
      String date = order.date!;
      if (dateCount.containsKey(date)) {
        dateCount[date] = dateCount[date]! + 1;
      } else {
        dateCount[date] = 1;
      }
    }
    return dateCount;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "รับงาน",
            style: TextStyle(fontFamily: "Itim"),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Column(
                children: [
                  FutureBuilder(
                    future: futureQueue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      final queue = snapshot.data!.data!;
                      return FutureBuilder(
                        future: futureDateStatus,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          final ordersDatestatus = snapshot.data!.data!;
                          final groupedDates = _groupDates(queue);

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: groupedDates.length,
                            itemBuilder: (context, index) {
                              String date = groupedDates.keys.elementAt(index);
                              int queueCount = groupedDates[date]!;
                              List<String> dateParts = date.split('-');

                              return ordersDatestatus[index].dateStatusStatus ==
                                          1 ||
                                      ordersDatestatus[index]
                                              .dateStatusStatus ==
                                          2
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          print(ordersDatestatus[index].date);
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => JobManege(
                                                id: widget.id,
                                                date: ordersDatestatus[index]
                                                    .date!,
                                                datestatusID:
                                                    ordersDatestatus[index]
                                                        .dateStatusId),
                                          ));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: getColorForStatus(
                                                  ordersDatestatus[index]
                                                      .dateStatusStatus!), // Adjust the status color
                                              boxShadow: [
                                                BoxShadow(
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    color: Colors.grey,
                                                    offset: Offset(3, 4))
                                              ]),
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.12,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  "${int.parse(dateParts[2])} ${Month[int.parse(dateParts[1]) - 1]} ${int.parse(dateParts[0]) + 543}",
                                                  style: TextStyle(
                                                      fontFamily: "Itim",
                                                      fontSize: 17),
                                                ),
                                                Text(" $queueCount คิว",
                                                    style: TextStyle(
                                                        fontFamily: "Itim",
                                                        fontSize: 17)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

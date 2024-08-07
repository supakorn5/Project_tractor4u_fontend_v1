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
  Map<String, int> dateCount = {};
  late Future<GetOrdersByuserId> futureOrders;
  late Future<GetDateStatus> futureDateStatus;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService().fetchOrders(widget.id!);
    futureDateStatus = OrderService().fetchDatestatus(widget.id!);
  }

  void countDates(List orders) {
    dateCount.clear();
    for (var order in orders) {
      if (dateCount.containsKey(order.date)) {
        dateCount[order.date] = dateCount[order.date]! + 1;
      } else {
        dateCount[order.date!] = 1;
      }
    }
  }

  Color getColorForStatus(int status) {
    switch (status) {
      case 1:
        return Color.fromARGB(255, 211, 215, 245); // สีฟ้า
      case 2:
        return Colors.yellow; // สีเหลือง // สีแดง
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
                  FutureBuilder<GetOrdersByuserId>(
                    future: futureOrders,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final orders = snapshot.data!.data!;
                      countDates(orders);

                      return FutureBuilder<GetDateStatus>(
                        future: futureDateStatus,
                        builder: (context, dateSnapshot) {
                          if (dateSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (dateSnapshot.hasError) {
                            return Text('Error: ${dateSnapshot.error}');
                          }

                          final dateStatusData = dateSnapshot.data!.data!;
                          Map<String, int> dateStatusMap = {};
                          for (var dateStatus in dateStatusData) {
                            dateStatusMap[dateStatus.date!.toString()] =
                                dateStatus.dateStatusStatus!;
                           
                          }
                          

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: dateCount.length,
                            itemBuilder: (context, index) {
                              String orderDate =
                                  dateCount.keys.elementAt(index);
                              int queueCount = dateCount[orderDate] ?? 0;
                              int dateStatus = dateStatusMap[orderDate] ?? 0;

                              List<String> dateParts = orderDate.split("-");
                              String day = int.parse(dateParts[2]).toString();
                              int month = int.parse(dateParts[1]);
                              int year = int.parse(dateParts[0]) + 543;

                              print("-=----dateStatusdata---");
                              print(dateStatusMap);
                              if (index < dateStatusData.length) {
                                int? currentStatusId =
                                    dateStatusData[index].dateStatusId;

                                return currentStatusId == 1 ||
                                        currentStatusId == 2
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: GestureDetector(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => JobManege(
                                                date: orderDate,
                                                id: widget.id,
                                                datestatusID: currentStatusId,
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(3, 4),
                                                  blurRadius: 1,
                                                ),
                                              ],
                                              color: getColorForStatus(
                                                  dateStatus),
                                            ),
                                            width: 350,
                                            height: 90,
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    "วันที่ $day ${Month[month - 1]} $year",
                                                    style: TextStyle(
                                                        fontFamily: "Itim",
                                                        fontSize: 17),
                                                  ),
                                                  Text(
                                                    "$queueCount คิว",
                                                    style: TextStyle(
                                                        fontFamily: "Itim",
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container();
                              } else {
                                return Container();
                              }
                            },
                          );
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

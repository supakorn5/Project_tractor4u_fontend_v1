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
  List<String> dateParts = [];
  late String date;
  int? owner_ID;
  late Future<GetDateStatusId> futuredataStatusID;
  late Future<GetQueueByDate> futureQueue;
  int? statusID;

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
                          SizedBox(
                            height: MediaQuery.of(context).size.height - 200,
                            child: ListView.builder(
                              itemCount: ordersQueue.length,
                              itemBuilder: (context, index) {
                                Color backgroundColor;
                                switch (ordersQueue[index].ordersStatus) {
                                  case 1:
                                    backgroundColor =
                                        Color.fromARGB(a, r, g, b);
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

                                for (var data in dateStatusData) {
                                  statusID = data.dateStatusId!;
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    print("date : " + widget.date!);
                                    print("ID : " + widget.id.toString());
                                    print("statusID : " + statusID.toString());
                                    if (ordersQueue[index].ordersStatus == 1) {
                                      _AlertJobconfirm(
                                        context,
                                        ordersQueue[index].ordersId!,
                                      );
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                            offset: Offset(4, 5)),
                                      ],
                                      color: backgroundColor,
                                    ),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    width: 350,
                                    height: 70,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "ลำดับคิวที่ ${index + 1}",
                                                style: const TextStyle(
                                                    fontFamily: "Prompt",
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${ordersQueue[index].usersUsername}",
                                            style: TextStyle(
                                                fontFamily: "Prompt",
                                                fontSize: 15),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${ordersQueue[index].landsSizeRai} ไร่",
                                                style: TextStyle(
                                                    fontFamily: "Prompt",
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                            onPressed: () {
                              print(statusID);
                              _AlertCloseJob(context, statusID!);
                            },
                            child: const Text(
                              "ปิดรับงาน",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Prompt",
                                  fontSize: 12),
                            ),
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

  void _AlertJobconfirm(BuildContext context, int OrderID) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '',
            style: TextStyle(fontFamily: "Prompt"),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'ท่านต้องการรับงานของลูกค้าคนนี้หรือไม่',
                style: TextStyle(fontFamily: "Prompt", fontSize: 19),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _ConfirmJob(OrderID, 6);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.redAccent,
                      ),
                      Text(
                        "  ไม่รับ",
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _ConfirmJob(OrderID, 2);
                    _updateDateStatus(2, statusID!);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.check,
                        color: Colors.greenAccent,
                      ),
                      Text(
                        "  รับ",
                        style: TextStyle(fontFamily: "Prompt"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
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

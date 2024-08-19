import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tractor4your/model/orders/getqueuebydate.dart';
import 'package:tractor4your/page/Owner/menu/JOB/job.dart';
import 'package:tractor4your/service/orders/OderService.dart';
import 'package:http/http.dart' as http;

class JobManege extends StatefulWidget {
  final int? id;
  final int? datestatusID;
  final String? date;
  JobManege({super.key, this.date, this.id, this.datestatusID});

  @override
  State<JobManege> createState() => _JobManegeState();
}

class _JobManegeState extends State<JobManege> {
  List<String> dateParts = [];
  late String date;
  int? owner_ID;
  late Future<GetQueueByDate> futureQueue;

  @override
  void initState() {
    super.initState();
    owner_ID = widget.id;
    date = widget.date!;
    dateParts = date.split('-');
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
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "จัดการงาน",
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
                        style: TextStyle(fontFamily: "Itim", fontSize: 25),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: Column(
                      children: [
                        Expanded(
                          child: FutureBuilder<GetQueueByDate>(
                            future: futureQueue,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              final ordersQueue = snapshot.data!.data!;
                              return ListView.builder(
                                itemCount: ordersQueue.length,
                                itemBuilder: (context, index) {
                                  Color backgroundColor;
                                  switch (ordersQueue[index].ordersStatus) {
                                    case 1:
                                      backgroundColor = Colors.amber;
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
                                  return Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (ordersQueue[index].ordersStatus ==
                                            1) {
                                          _AlertJobconfirm(context,
                                              ordersQueue[index].ordersId!);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2,
                                                offset: Offset(4, 5)),
                                          ],
                                          color: backgroundColor,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
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
                                                        fontFamily: "Itim",
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "${ordersQueue[index].usersUsername}",
                                                style: TextStyle(
                                                    fontFamily: "Itim",
                                                    fontSize: 15),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${ordersQueue[index].landsSizeRai} ไร่",
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () {
                            _AlertCloseJob(context);
                          },
                          child: const Text(
                            "ปิดรับงาน",
                            style: TextStyle(
                                color: Colors.black, fontFamily: "Itim"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _AlertJobconfirm(BuildContext context, int OrderID) {
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
                'ท่านต้องการรับงานของลูกค้าคนนี้หรือไม่',
                style: TextStyle(fontFamily: "Itim"),
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
                        style: TextStyle(fontFamily: "Itim"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print(widget.datestatusID);
                    // _ConfirmJob(OrderID, 2);
                    // _updateDateStatus(2, widget.datestatusID!);
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
                        style: TextStyle(fontFamily: "Itim"),
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
    final url = Uri.parse(
        "http://10.0.2.47:5000/api/orders/Resever"); // Replace with your machine's IP address
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
    final url = Uri.parse(
        "http://192.168.122.217:5000/api/orders/UpdateDateStatus"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({"datestatus": datestatus, "dateStatus_id": statusID});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['data']);
      print("UpdateComplete");
      _refreshQueue(); // Refresh the queue after successful status update
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }

  void _AlertCloseJob(BuildContext context) {
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
                'ท่านต้องการปิดรับงานของวันนี้หรือไม่',
                style: TextStyle(fontFamily: "Itim"),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _updateDateStatus(3, widget.datestatusID!);
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.check,
                        color: Colors.greenAccent,
                      ),
                      Text(
                        "  ปิด",
                        style: TextStyle(fontFamily: "Itim"),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: const [
                      Icon(
                        FontAwesomeIcons.xmark,
                        color: Colors.redAccent,
                      ),
                      Text(
                        "  ไม่ปิด",
                        style: TextStyle(fontFamily: "Itim"),
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
}

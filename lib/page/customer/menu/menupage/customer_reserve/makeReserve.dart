import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/service/users/users_services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tractor4your/service/owners/owners_services.dart';

class makeReserve extends StatefulWidget {
  final int? owners_id;
  final int? users_id;
  final int? lands_id;
  const makeReserve(
      {super.key, required this.owners_id, this.users_id, this.lands_id});

  @override
  State<makeReserve> createState() => _makeReserveState();
}

class _makeReserveState extends State<makeReserve> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String year = '${DateTime.now().year + 543}';

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  List<dynamic> ownersInfo = [];
  Map<int, List<dynamic>> ownersDateStatus =
      {}; //ไว้รับข้อมูลจาก load_api_getDateStatus
  List<dynamic> orderBydate = [];
  List<dynamic> dateStatus = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load_api_getOwnerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'จองคิว',
          style: TextStyle(fontFamily: "Prompt"),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (ownersInfo.isNotEmpty && ownersDateStatus.isNotEmpty) ...[
                _buildOwnerInfo(ownersInfo[0]),
                _buildCalendar(dateStatus, ownersInfo[0]['owners_id']),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerInfo(dynamic owner) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 75,
                height: 75,
                child: CircleAvatar(
                  backgroundImage:
                      MemoryImage(base64Decode(owner['users_image'])),
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('rate', style: TextStyle(fontSize: 16)),
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 20.0,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${owner['users_username']}',
                  style: TextStyle(fontSize: 28)),
              Text('${owner['owners_price_rai']} บาท/ไร่',
                  style: TextStyle(fontSize: 16)),
              Text('${owner['owners_price_ngan']} บาท/งาน',
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('12', style: TextStyle(fontSize: 32)),
              Text('กม.', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(List<dynamic> data, int owners_id) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   border: Border.all(color: Colors.black, width: 1),
      // ),
      child: Column(children: [
        TableCalendar(
          locale: 'th_TH',
          firstDay: kFirstDay,
          lastDay: kLastDay,
          headerStyle: HeaderStyle(
            titleTextFormatter: (date, locale) =>
                '${DateFormat.MMMMd(locale).format(date)} $year',
            titleCentered: true,
            leftChevronPadding: EdgeInsets.all(0),
            rightChevronPadding: EdgeInsets.all(0),
          ),
          daysOfWeekHeight: 16.0,
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: {CalendarFormat.month: 'Month'},
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            }
            //ถ้าเป็นไม่เป็นอดีต แสดง popup
            if (selectedDay!.isAfter(DateTime.now())) {
              //showQueueByDate(context, owners_id, selectedDay);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            year = '${(focusedDay.year + 543)}';
          },

          //add event to date
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              for (var status in data) {
                if (DateFormat('yyyy-MM-dd').format(day) ==
                    status['dateStatus_date']) {
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _getColorForStatus(status['dateStatus_status']),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 246, 177, 122)),
            onPressed: () {
              print('on press');
              //print('Current focused date: $_focusedDay, Selected date: $_selectedDay');
              if (_selectedDay!.isAfter(DateTime.now())) {
                //print('select is future');
                load_api_Reserve(DateTime.now(), _selectedDay, widget.lands_id,
                    widget.users_id, owners_id);
                load_api_getOwnerInfo();
              } else {
                //print('select is past');
                load_api_getOwnerInfo();
                alertDateNotCorrect(2);
              }
            },
            child: const Text(
              "จองคิว",
              style: TextStyle(
                  fontSize: 20, fontFamily: "Prompt", color: Colors.black),
            )),
      ]),
    );
  }

  Color _getColorForStatus(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> showQueueByDate(
      BuildContext context, int owners_id, DateTime selectedDay) async {
    final orderByDate = await load_api_getOrderByDate(owners_id, selectedDay);
    if (orderByDate == null || orderByDate.isEmpty) {
      print("ว่าง");
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Owner_ID: $owners_id" + " จำนวนคิว"),
          content: Container(
            height: 400, // You can set a specific height for the container
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: orderByDate.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text("Order_id: ${orderByDate[index]['orders_users_id']}"),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> showQueueByDate(
  //     BuildContext context, int owners_id, DateTime selectedDay) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Owner_ID: $owners_id" + " จำนวนคิว"),
  //         content: FutureBuilder<List>(
  //           future: load_api_getOrderByDate(owners_id, selectedDay),
  //           builder: (context, snapshot) {
  //             if (snapshot.connectionState == ConnectionState.waiting) {
  //               return CircularProgressIndicator();
  //             } else if (snapshot.hasError) {
  //               return Text("Error: ${snapshot.error}");
  //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //               return Text("ไม่มีการจองคิวในวันนี้");
  //             } else {
  //               List orderBydate = snapshot.data!;
  //               return Container(
  //                 height: 400,
  //                 width: double.maxFinite,
  //                 child: ListView.builder(
  //                   itemCount: orderBydate.length,
  //                   itemBuilder: (context, index) {
  //                     return Column(
  //                       children: [
  //                         Text(
  //                             "user_id: ${orderBydate[index]['orders_users_id']}")
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               );
  //             }
  //           },
  //         ),
  //         actions: [
  //           TextButton(
  //             child: Text("OK"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _buildOwnerTractor(dynamic ownersData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            child: Image.memory(
              base64Decode(ownersInfo[0]['users_image']),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  //แจ้งว่าจองไม่ได้เพราะวันที่เลือกเป็นอดีต
  Future<void> alertDateNotCorrect(int status) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        if (status == 1) {
          return AlertDialog(
            title: const Text(
              'จองคิวสำร็จ',
              style: TextStyle(fontFamily: "Prompt"),
            ),
            // content: const Text(
            //   'วันที่เลือกไม่ถูกต้อง',
            //   style: TextStyle(fontFamily: "Itim"),
            // ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('ตกลง'),
              ),
            ],
          );
        } else {
          return AlertDialog(
            title: const Text(
              'ไม่สามารถจองคิวได้',
              style: TextStyle(fontFamily: "Prompt"),
            ),
            content: const Text(
              'วันที่เลือกไม่ถูกต้อง',
              style: TextStyle(fontFamily: "Prompt"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('ตกลง'),
              ),
            ],
          );
        }
      },
    );
  }

  Future<void> load_api_getOwnerInfo() async {
    List<dynamic> data = await api_getOwnerInfo(widget.owners_id);
    for (var owner in data) {
      await load_api_getDateStatus(owner['owners_id']);
    }
    setState(() {
      ownersInfo = data;
      dateStatus = ownersDateStatus[ownersInfo[0]['owners_id']] ?? [];
    });
  }

  Future<void> load_api_getDateStatus(int owners_id) async {
    List<dynamic> data = await api_getDateStatus(owners_id);
    setState(() {
      ownersDateStatus[owners_id] = data;

      //   print("---------------- this in load api getDateStatus make reserve ---------------");
      //   print(ownersDateStatus);
    });
  }

  Future<List<dynamic>>? load_api_getOrderByDate(
      int owners_id, DateTime selectedDay) async {
    List<dynamic> data = await api_getOrderByDate(owners_id, selectedDay);
    return data;
  }

  Future<void> load_api_Reserve(DateTime reserve_date, DateTime? start_date,
      int? lands_id, int? users_id, int owners_id) async {
    // print('----------------reserve--------------');
    // print('Current focused date: $reserve_date, Selected date: $start_date');
    // print(lands_id);
    // print(users_id);
    // print(owners_id);
    await api_Reserve(reserve_date, start_date, lands_id, users_id, owners_id);
    alertDateNotCorrect(1);
  }
}

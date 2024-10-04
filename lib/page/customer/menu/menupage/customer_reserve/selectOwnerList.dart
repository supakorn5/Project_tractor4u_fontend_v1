import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'makeReserve.dart';
import 'package:tractor4your/service/owners/owners_services.dart';

class SelectOwnerList extends StatefulWidget {
  final int? users_id;
  final int? lands_id;

  //const SelectOwnerList({super.key, required this.users_id, this.lands_id});
  SelectOwnerList({super.key, this.users_id, this.lands_id});

  @override
  State<SelectOwnerList> createState() => _SelectOwnerListState();
}

class _SelectOwnerListState extends State<SelectOwnerList> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String year = '${DateTime.now().year + 543}';

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  List<dynamic> ownersData = [];
  Map<int, List<dynamic>> ownersDateStatus =
      {}; //ไว้รับข้อมูลจาก load_api_getDateStatus
  final searchController = TextEditingController();
  List<dynamic> orderBydate = [];

  @override
  void initState() {
    super.initState();
    loadOwnersData(); // Preload data
    //load_api_selectOwnerOpenFullInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 238, 177, 127),
        title: const Text(
          "เลือกเข้าของรถไถ",
          style: TextStyle(fontFamily: "Prompt"),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          children: [
            _search(),
            _OwnerList(),
          ],
        ),
      ),
    ));
  }

  Widget _OwnerList() {
    return Expanded(
      child: ListView.builder(
        itemCount: ownersData.length,
        itemBuilder: (context, index) {
          final dateStatus =
              ownersDateStatus[ownersData[index]['owners_id']] ?? [];
          return Card(
            child: Column(
              children: [
                if (dateStatus.isNotEmpty) ...[
                  _buildOwnerInfo(ownersData[index]),
                  _buildCalendar(dateStatus, ownersData[index]['owners_id']),
                ] else ...[
                  _buildOwnerInfo(ownersData[index]),
                  _buildCalendarNoDateStatus(ownersData[index]['owners_id']),
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  // Widget _OwnerList() {
  //   print("call ownerlist ");
  //   return ListView.builder(
  //     itemCount: ownersData.length,
  //     physics: BouncingScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       final dateStatus =
  //           ownersDateStatus[ownersData[index]['owners_id']] ?? [];
  //       return RepaintBoundary(
  //         // Added for performance
  //         child: Card(
  //           child: Column(
  //             children: [
  //               _buildOwnerInfo(ownersData[index]),
  //               dateStatus.isNotEmpty
  //                   ? _buildCalendar(dateStatus, ownersData[index]['owners_id'])
  //                   : _buildCalendarNoDateStatus(
  //                       ownersData[index]['owners_id']),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _search() {
    return TextFormField(
        controller: searchController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
          labelText: "ค้นหา",
          labelStyle: TextStyle(
            fontFamily: "Prompt",
            color: Colors.black,
          ),
        ));
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
          // selectedDayPredicate: (day) {
          //   return isSameDay(_selectedDay, day);
          // },
          // onDaySelected: (selectedDay, focusedDay) {
          //   if (!isSameDay(_selectedDay, selectedDay)) {
          //     setState(() {
          //       _selectedDay = selectedDay;
          //       _focusedDay = focusedDay;
          //     });
          //     showQueueByDate(context, owners_id, selectedDay);
          //   }
          // },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            year = '${(focusedDay.year + 543)}';
          },

          //add event to date
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              for (var status in data) {
                if (DateFormat('yyyy-MM-dd').format(day) ==
                    status['ownerCalendar_date']) {
                  return Container(
                    margin: const EdgeInsets.all(2.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _getColorForStatus(status['ownerCalendar_status']),
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
              Get.to(() => makeReserve(
                  owners_id: owners_id,
                  users_id: widget.users_id,
                  lands_id: widget.lands_id));
            },
            child: const Text(
              "เพิ่มเติม",
              style: TextStyle(
                  fontSize: 20, fontFamily: "Prompt", color: Colors.black),
            )),
      ]),
    );
  }

  Widget _buildCalendarNoDateStatus(int owners_id) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
              showQueueByDate(context, owners_id, selectedDay);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            year = '${(focusedDay.year + 543)}';
          },
        ),
        SizedBox(height: 10),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 246, 177, 122)),
            onPressed: () {
              Get.to(() => makeReserve(
                  owners_id: owners_id,
                  users_id: widget.users_id,
                  lands_id: widget.lands_id));
            },
            child: const Text(
              "เพิ่มเติม",
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
  //                 height:
  //                     400, // You can set a specific height for the container
  //                 width: double.maxFinite,
  //                 child: ListView.builder(
  //                   itemCount: orderBydate.length,
  //                   itemBuilder: (context, index) {
  //                     return Column(
  //                       children: [
  //                         Text(
  //                             "Order_id: ${orderBydate[index]['orders_users_id']}")
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

  Future<void> loadOwnersData() async {
    List<dynamic> data = await api_selectOwnerOpenFullInfo();
    for (var owner in data) {
      await load_api_getDateStatus(owner['owners_id']);
    }
    setState(() {
      ownersData = data;
    });
  }

  Future<void> load_api_selectOwnerOpenFullInfo() async {
    List<dynamic> data = await api_selectOwnerOpenFullInfo();
    for (var owner in data) {
      await load_api_getDateStatus(owner['owners_id']);
    }
    setState(() {
      ownersData = data;
      print(
          "============= load api select owner open full info====================");
      print(ownersData);
    });
  }

  Future<void> load_api_getDateStatus(int owners_id) async {
    List<dynamic> data = await api_getDateStatus(owners_id);
    setState(() {
      ownersDateStatus[owners_id] = data;
    });
    //print('---------------this in load_api_getDateStatus ---------------');
  }

  Future<List<dynamic>>? load_api_getOrderByDate(
      int owners_id, DateTime selectedDay) async {
    List<dynamic> data = await api_getOrderByDate(owners_id, selectedDay);
    return data;
    // setState(() {
    //   orderBydate = data;
    // });
    // print('---------------this in load_api_getOrderByDate ---------------');
    // print(orderBydate);
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/model/orders/getJobbyuser_id.dart' as job;
import 'package:tractor4your/model/orders/getdatestatus.dart';
import 'package:tractor4your/model/orders/getuserID.dart';
import 'package:tractor4your/page/Owner/menu/JOB/Jobmanage.dart';
import 'package:tractor4your/service/orders/OderService.dart';

class Job extends StatefulWidget {
  final int? id;
  Job({super.key, this.id});

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  DateTime Today = DateTime.now();
  DateTime? _selectedDay;
  int? owner_ID;
  Map<DateTime, List<String>> _events = {};
  late Future<Getdatestatus> futuredateStatusList;
  late Future<job.GetJobbyuserId> futureQueue;
  late Future<GetuserId> futureUserID;
  int? UserID;
  Map<DateTime, int> dateStatusMap = {};

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

  @override
  void initState() {
    super.initState();
    owner_ID = widget.id;
    futureUserID = OrderService().fetchuserID(widget.id!);
    futureQueue = OrderService().fetchOrders(widget.id!);
    futuredateStatusList = OrderService().fetchdateStatus(widget.id!);
    _initializeEvents();
    _initializeDateStatus();
  }

  bool _eventsInitialized = false;
  bool _dateStatusInitialized = false;

  Future<void> _initializeDateStatus() async {
    if (!_dateStatusInitialized) {
      try {
        final dateStatus = await futuredateStatusList;
        final dateStatusList = dateStatus.data;

        for (var dateStatus in dateStatusList!) {
          if (dateStatus.date != null && dateStatus.dateStatusStatus != null) {
            DateTime dateKey = DateTime.parse(dateStatus.date!.toString());
            DateTime strippedDateKey =
                DateTime(dateKey.year, dateKey.month, dateKey.day);
            dateStatusMap[strippedDateKey] = dateStatus.dateStatusStatus!;
          }
        }

        setState(() {
          _dateStatusInitialized = true;
        });
      } catch (e) {
        print('Error fetching date statuses: $e');
      }
    }
  }

  Future<void> _initializeEvents() async {
    if (!_eventsInitialized) {
      try {
        final result = await futureQueue;
        final List<job.Datum>? orders = result.data;

        if (orders != null && orders.isNotEmpty) {
          final Map<DateTime, List<String>> events = {};

          for (var order in orders) {
            if (order.date != null) {
              final date = order.date!;
              DateTime strippedDate = DateTime(date.year, date.month, date.day);

              if (events[strippedDate] == null) {
                events[strippedDate] = [];
              }

              events[strippedDate]!.add(order.usersUsername ?? 'Unknown User');
            }
          }

          setState(() {
            _events = events;
            _eventsInitialized = true;
          });
        }
      } catch (e) {
        print('Error fetching orders: $e');
      }
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    DateTime strippedDay = DateTime(day.year, day.month, day.day);
    return _events[strippedDay] ?? [];
  }

  String _formatYearToBE(int year) {
    return (year + 543).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(a, r, g, b),
          title: const Text(
            "รับงาน",
            style: TextStyle(fontFamily: "Prompt"),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshData, // Trigger refresh
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  FutureBuilder(
                    future: Future.delayed(Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      return Container(
                        child: TableCalendar(
                          locale: "th_TH",
                          rowHeight: 43,
                          calendarFormat: CalendarFormat.month,
                          availableGestures: AvailableGestures.all,
                          headerStyle: HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextFormatter: (date, locale) {
                              final formattedYear = _formatYearToBE(date.year);
                              return '${Month[date.month - 1]} พ.ศ. $formattedYear';
                            },
                            titleTextStyle:
                                TextStyle(fontFamily: "Prompt", fontSize: 20),
                          ),
                          focusedDay: Today,
                          firstDay: DateTime.utc(2020, 1, 1),
                          lastDay: DateTime.utc(2040, 12, 31),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedDay = selectedDay;
                              Today = focusedDay;
                            });
                          },
                          eventLoader: (day) {
                            return _getEventsForDay(day);
                          },
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              DateTime strippedDay =
                                  DateTime(day.year, day.month, day.day);

                              if (dateStatusMap.containsKey(strippedDay)) {
                                int status = dateStatusMap[strippedDay]!;
                                Color bgColor;

                                if (status == 2) {
                                  bgColor = Colors.yellow.withOpacity(0.6);
                                } else if (status == 3) {
                                  bgColor = Colors.red.withOpacity(0.6);
                                } else {
                                  bgColor = Colors.blue.withOpacity(0.3);
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }

                              return null;
                            },
                            markerBuilder: (context, day, events) {
                              if (events.isNotEmpty) {
                                return Positioned(
                                  bottom: 1,
                                  right: -1,
                                  child: _buildEventMarker(events.length),
                                );
                              }
                              return null;
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  _selectedDay != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: Size(100, 50),
                                    backgroundColor:
                                        Colors.greenAccent.shade100),
                                onPressed: () async {
                                  if (_selectedDay != null) {
                                    DateTime strippedSelectedDay = DateTime(
                                      _selectedDay!.year,
                                      _selectedDay!.month,
                                      _selectedDay!.day,
                                    );
                                    int? dateStatusId =
                                        dateStatusMap[strippedSelectedDay];

                                    if (dateStatusId != null) {
                                      // Wait for the result from JobManege page
                                      final update = await Get.to(
                                        () => JobManege(
                                          date: _selectedDay
                                              .toString()
                                              .split(" ")
                                              .first,
                                          id: widget.id,
                                        ),
                                      );

                                      if (update == 1) {
                                        setState(() {
                                          log("${update}");
                                          log("Refreshing data...");
                                          futureUserID = OrderService()
                                              .fetchuserID(widget.id!);
                                          futureQueue = OrderService()
                                              .fetchOrders(widget.id!);
                                          futuredateStatusList = OrderService()
                                              .fetchdateStatus(widget.id!);

                                          _initializeEvents(); // re-initialize events
                                          _initializeDateStatus(); // re-initialize date status
                                        });
                                      }
                                    } else {
                                      Get.snackbar("แจ้งเตือน",
                                          "วันที่คุณเลือกไม่มีข้อมูลกรุณาเลือกวันอื่น");
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'กรุณากดเลือกวันที่',
                                          style:
                                              TextStyle(fontFamily: "Prompt"),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'ต่อไป',
                                  style: TextStyle(
                                      fontFamily: "Prompt",
                                      color: Colors.black),
                                ),
                              ),
                            ),
                            Text(
                              'ลูกค้าที่มาจองวันที่ ${_selectedDay!.day} ${Month[_selectedDay!.month - 1]} ${_formatYearToBE(_selectedDay!.year)}',
                              style:
                                  TextStyle(fontSize: 16, fontFamily: "Prompt"),
                            ),
                            ..._getEventsForDay(_selectedDay!).map(
                              (event) => ListTile(
                                title: Text(
                                  event,
                                  style: TextStyle(fontFamily: "Prompt"),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(""),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      futureUserID = OrderService().fetchuserID(widget.id!);
      futureQueue = OrderService().fetchOrders(widget.id!);
      futuredateStatusList = OrderService().fetchdateStatus(widget.id!);

      _initializeEvents();
      _initializeDateStatus();
    });
  }
}

Widget _buildEventMarker(int eventCount) {
  return Container(
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
    width: 15.0,
    height: 15.0,
    child: Center(
      child: Text(
        eventCount.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/service/users/users_services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tractor4your/service/owners/owners_services.dart';

class cus_status extends StatefulWidget {
  late int? users_id;

  @override
  State<cus_status> createState() => _cus_statusState();
}

class _cus_statusState extends State<cus_status> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String year = '${DateTime.now().year + 543}';

  final kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
  final kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          child: Column(),
        ),
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
      ]),
    );
  }
}

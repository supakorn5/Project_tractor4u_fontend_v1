import 'dart:convert';

import 'package:flutter/material.dart';
import 'selectowner.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class makeReserve extends StatefulWidget {
  final dynamic ownersData;
  const makeReserve({super.key, required this.ownersData});

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _GetOwnerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จองคิว'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              if (ownersInfo.isNotEmpty) ...[
                _buildOwnerInfo(widget.ownersData),
                _buildCalendar(),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    dynamic dateReserve;
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(children: [
        Text('เลือกวันที่จอง', style: TextStyle(fontSize: 20)),
        TableCalendar(
          locale: 'th_TH',
          firstDay: kFirstDay,
          lastDay: kLastDay,
          headerStyle: HeaderStyle(
            titleTextFormatter: (date, locale) =>
                '${DateFormat.MMMMd(locale).format(date)} $year',
          ),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          availableCalendarFormats: {CalendarFormat.month: 'month'},
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
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            year = '${(focusedDay.year + 543)}';
          },
        ),
        SizedBox(height: 20),
        // Text(
        //   _selectedDay != null
        //       ? DateFormat('dd-MM-yyyy').format(_selectedDay!)
        //       : 'เลือกวันที่จอง',
        //   style: TextStyle(fontSize: 16),
        // ),
      ]),
    );
  }

  Widget _buildOwnerInfo(dynamic ownersData) {
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
                      MemoryImage(base64Decode(ownersInfo[0]['users_image'])),
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
              Text('${ownersInfo[0]['users_username']}',
                  style: TextStyle(fontSize: 28)),
              Text('${ownersInfo[0]['owners_price_rai']} บาท/ไร่',
                  style: TextStyle(fontSize: 16)),
              Text('${ownersInfo[0]['owners_price_ngan']} บาท/งาน',
                  style: TextStyle(fontSize: 16)),
              Text('3 คิว', style: TextStyle(fontSize: 16)),
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

  Future<void> _GetOwnerInfo() async {
    final url = Uri.parse(
        "http://10.0.2.4:5000/api/owners/GetOwnersInfo"); //My laptop
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "owners_id": widget.ownersData['owners_id'],
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      setState(() {
        ownersInfo = decodeResponse['data'];
      });

      print('----------------GetOwnerInfo----------');
      print(ownersInfo);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }
}

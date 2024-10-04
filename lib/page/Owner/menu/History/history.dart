import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/page/Owner/Owner_mainMenu.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Color.fromARGB(a, r, g, b),
                title: const Text(
                  "ประวัติการทำงาน",
                  style: TextStyle(fontFamily: "Prompt"),
                ),
                leading: IconButton(
                    onPressed: () {
                      Get.close(2);
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ))));
  }
}

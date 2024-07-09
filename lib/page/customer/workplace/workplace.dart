import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tractor4your/page/customer/menu/menubottombar.dart';
import 'package:tractor4your/page/customer/workplace/addworkplace.dart';

class Workplace extends StatefulWidget {
  const Workplace({super.key});

  @override
  State<Workplace> createState() => _WorkplaceState();
}

class _WorkplaceState extends State<Workplace> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "เลือกพื้นที่ต้องการไถ",
            style: TextStyle(fontFamily: "Itim"),
          ),
          leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.transparent,
              )),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MenuBottombar(),
                      ),
                    ),
                    child: const Text("Route"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Addworkplace(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_location_alt),
                      )
                    ],
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

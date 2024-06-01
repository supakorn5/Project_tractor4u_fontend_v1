import 'package:flutter/material.dart';

class SelectOwner extends StatefulWidget {
  const SelectOwner({super.key});

  @override
  State<SelectOwner> createState() => _SelectOwnerState();
}

class _SelectOwnerState extends State<SelectOwner> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 177, 122),
        title: const Text(
          "เลือกเข้าของรถไถ",
          style: TextStyle(fontFamily: "Itim"),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
    ));
  }
}

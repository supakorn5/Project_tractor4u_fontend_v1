import 'package:flutter/material.dart';

class PayMoney extends StatefulWidget {
  const PayMoney({super.key});

  @override
  State<PayMoney> createState() => _PayMoneyState();
}

class _PayMoneyState extends State<PayMoney> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 177, 122),
        title: const Text(
          "ชำระเงิน",
          style: TextStyle(fontFamily: "Prompt"),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              //color: Colors.transparent,
            )),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
      ),
    ));
  }
}

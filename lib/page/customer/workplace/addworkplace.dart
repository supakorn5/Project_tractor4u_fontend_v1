import 'package:flutter/material.dart';
import 'package:tractor4your/page/customer/workplace/map_page.dart';

class Addworkplace extends StatefulWidget {
  const Addworkplace({super.key});

  @override
  State<Addworkplace> createState() => _AddworkplaceState();
}

class _AddworkplaceState extends State<Addworkplace> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "เพิ่มตำแหน่งของงาน",
            style: TextStyle(fontFamily: "Itim"),
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MapPage()));
                    },
                    child: const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Image(
                            image: AssetImage("assets/icon/map.png"),
                            height: 30,
                            width: 30,
                          ),
                        ),
                        Text(
                          "เพิ่มตำแหน่งของที่ทำงาน",
                          style: TextStyle(
                              fontFamily: "Itim", color: Colors.black),
                        )
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        labelText: "กรอกข้อมูลที่ดิน",
                        labelStyle: TextStyle(fontFamily: "Itim"),
                        hintText: "เช่น นายายศรี ข้างบ้านลุงหมื่น ใกล้ๆเมรุ",
                        hintStyle: TextStyle(fontFamily: "Itim")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        labelText: "กรอกข้อมูลจำนวนไร่",
                        labelStyle: TextStyle(fontFamily: "Itim"),
                        hintText: "เช่น 15 ไร่ 20 ไร่",
                        hintStyle: TextStyle(fontFamily: "Itim")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        labelText: "กรอกข้อมูลจำนวนงาน",
                        labelStyle: TextStyle(fontFamily: "Itim"),
                        hintText: "เช่น 3 งาน 1 งาน",
                        hintStyle: TextStyle(fontFamily: "Itim")),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    width: 320,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 246, 177, 122),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "ยืนยัน",
                          style: TextStyle(
                              fontFamily: "Itim", color: Colors.black),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

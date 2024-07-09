import 'package:flutter/material.dart';
import 'package:tractor4your/page/customer/menu/mainMenu.dart';
import 'package:tractor4your/page/customer/menu/menubottombar.dart';
import 'package:tractor4your/page/customer/workplace/addworkplace.dart';
import '../../../service/lands/LandService.dart';
import '../../../model/lands/getlandsbyuser_id.dart';

class Workplace extends StatefulWidget {
  final int? id;
  const Workplace({Key? key, this.id}) : super(key: key);

  @override
  State<Workplace> createState() => _WorkplaceState();
}

class _WorkplaceState extends State<Workplace> {
  late Future<Getlandsbyuserid> futureLands;

  @override
  void initState() {
    super.initState();
    futureLands = LandService().fetchLand(widget.id!); // Initialize futureLands
  }

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
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Addworkplace(id: widget.id, mapdata: const []),
                    ),
                  );
                },
                icon: const Icon(Icons.add_location_alt_rounded))
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FutureBuilder<Getlandsbyuserid>(
                    future: futureLands, // Use the futureLands future
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        ); // Loading indicator
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Error message
                      } else if (!snapshot.hasData ||
                          snapshot.data!.success == false ||
                          snapshot.data!.data!.isEmpty) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ไม่มีข้อมูลที่ดินคลิกที่บนมุมขวาเพื่อเพิ่ม",
                              style: TextStyle(fontFamily: "Itim"),
                            ),
                          ],
                        ); // No data message
                      } else {
                        // Data is loaded
                        final lands = snapshot.data!.data!;
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: lands.length,
                          itemBuilder: (context, index) {
                            final land = lands[index];
                            return Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MenuBottombar(
                                                        id: widget.id!,
                                                      )));
                                          print(land.landsId);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: const Color.fromARGB(
                                                  255, 246, 177, 122)),
                                          width: 300,
                                          height: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "รายละเอียดที่ดิน : ${land.landsInfo}",
                                                      style: const TextStyle(
                                                          fontFamily: "Itim"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "จำนวน : ${land.landsSizeRai} ไร่ ${land.landsSizeNgan} งาน",
                                                      style: const TextStyle(
                                                          fontFamily: "Itim"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

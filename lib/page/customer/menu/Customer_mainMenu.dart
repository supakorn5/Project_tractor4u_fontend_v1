import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/page/customer/menu/menupage/profile/profile.dart';
import 'package:tractor4your/page/customer/menu/menupage/selectOwnerList.dart';

class MainMenu extends StatefulWidget {
  final int? id;
  final int? lands_id;
  const MainMenu({super.key, this.id, this.lands_id});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int? id;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(a, r, g, b),
          title: const Text(
            "หน้าหลัก",
            style: TextStyle(fontFamily: "Prompt"),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
                // Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
              )),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25))),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.only(top: 30),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  if (widget.lands_id == 0) {
                    alertGobackSelectLand();
                  } else {
                    Get.to(() => SelectOwnerList(
                        users_id: id!, lands_id: widget.lands_id));
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green.shade100,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/icon/farmer.png"),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "เลือกเจ้าของรถไถ",
                        style: TextStyle(fontFamily: "Prompt", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => print(2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue.shade100,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/icon/hard-work.png"),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "สถานะการทำงาน",
                        style: TextStyle(fontFamily: "Prompt", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => print(3),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade400,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/icon/time.png"),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "ประวัติ",
                        style: TextStyle(fontFamily: "Prompt", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.to(() => Profile(id: id!)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade50,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/icon/user.png"),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "ข้อมูลส่วนตัว",
                        style: TextStyle(fontFamily: "Prompt", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.off(() => Login_Page()),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade50,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5, 5),
                        blurRadius: 1,
                      )
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/icon/logout.png"),
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "ออกจากระบบ",
                        style: TextStyle(fontFamily: "Prompt", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> alertGobackSelectLand() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'คำตือน!',
            style: TextStyle(fontFamily: "Prompt"),
          ),
          content: const Text(
            'กรุณาเลือกที่ดินก่อนที่จะเลือกเจ้าของรถไถ',
            style: TextStyle(fontFamily: "Prompt"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: const Text('เลือกเจ้าของรถไถ'),
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('เลือกภายหลัง'),
            ),
          ],
        );
      },
    );
  }
}

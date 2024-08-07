import 'package:flutter/material.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/page/customer/menu/menupage/profile/profile.dart';
import 'package:tractor4your/page/customer/menu/menupage/selectOwnerList.dart';
import 'package:tractor4your/page/customer/menu/menupage/selectowner.dart';

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
          backgroundColor: const Color.fromARGB(255, 246, 177, 122),
          title: const Text(
            "หน้าหลัก",
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SelectOwnerList(
                            users_id: id!, lands_id: widget.lands_id)));
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
                        style: TextStyle(fontFamily: "Itim", fontSize: 20),
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
                        style: TextStyle(fontFamily: "Itim", fontSize: 20),
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
                        style: TextStyle(fontFamily: "Itim", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Profile(id: id!),
                )),
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
                        style: TextStyle(fontFamily: "Itim", fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Login_Page(),
                  ),
                  (Route<dynamic> route) => false, // Remove all routes
                ),
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
                        style: TextStyle(fontFamily: "Itim", fontSize: 20),
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
            style: TextStyle(fontFamily: "Itim"),
          ),
          content: const Text(
            'กรุณาเลือกที่ดินก่อนที่จะเลือกเจ้าของรถไถ',
            style: TextStyle(fontFamily: "Itim"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  //exit from alert to main
                Navigator.of(context).pop();  //exit from main to select Land
              },
              child: const Text('เลือกเจ้าของรถไถ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('เลือกภายหลัง'),
            ),
          ],
        );
      },
    );
  }
}

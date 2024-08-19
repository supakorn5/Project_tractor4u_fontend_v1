import 'package:flutter/material.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/model/orders/getownerID.dart';
import 'package:tractor4your/page/Owner/menu/JOB/job.dart';
import 'package:tractor4your/service/orders/OderService.dart';
import 'package:lottie/lottie.dart';

class Owner_mainMenu extends StatefulWidget {
  final int? id;
  Owner_mainMenu({super.key, this.id});

  @override
  State<Owner_mainMenu> createState() => _Owner_mainMenuState();
}

class _Owner_mainMenuState extends State<Owner_mainMenu> {
  late Future<GetOwnerId> futureOwnerID;
  int? owner_ID;

  @override
  void initState() {
    super.initState();
    // Initialize futureOwnerID with a default value
    owner_ID = widget.id;
    futureOwnerID = Future.value(GetOwnerId());
    if (widget.id != null) {
      futureOwnerID = OrderService().fetchOwnerID(owner_ID!);
    }
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
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.transparent,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
        ),
        body: FutureBuilder<GetOwnerId>(
          future: Future.delayed(Duration(seconds: 2), () => futureOwnerID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Lottie.asset(
                    "assets/animation/Animation - 1723570737186.json"),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data?.data == null) {
              return Center(child: Text('No owner data available'));
            } else {
              final ownerId = snapshot.data!.data!;
              return GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.only(top: 30),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Job(id: ownerId[0].ownersId),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color.fromARGB(255, 255, 255, 255),
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
                              image: AssetImage("assets/icon/job-search.png"),
                              width: 100,
                              height: 100,
                            ),
                            Text(
                              "รับงาน",
                              style:
                                  TextStyle(fontFamily: "Itim", fontSize: 20),
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
                              style:
                                  TextStyle(fontFamily: "Itim", fontSize: 20),
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
                              style:
                                  TextStyle(fontFamily: "Itim", fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
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
                              style:
                                  TextStyle(fontFamily: "Itim", fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
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
                              style:
                                  TextStyle(fontFamily: "Itim", fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

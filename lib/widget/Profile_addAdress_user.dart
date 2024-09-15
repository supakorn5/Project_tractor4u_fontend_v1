import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tractor4your/CodeColorscustom.dart';
import 'package:tractor4your/Ipglobals.dart';
import 'package:tractor4your/model/users/provinceinTH.dart' as model;
import 'package:tractor4your/service/users/ProvinceandDistict.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class ProfilAddAddressUser extends StatefulWidget {
  final int? userID;
  ProfilAddAddressUser({super.key, this.userID});

  @override
  State<ProfilAddAddressUser> createState() => _ProfilAddAddressUserState();
}

class _ProfilAddAddressUserState extends State<ProfilAddAddressUser> {
  final banLekte = TextEditingController();

  late Future<List<model.ProvinceinTh>> _provincesFuture;
  List<model.ProvinceinTh> _districts = [];
  List<model.ProvinceinTh> _subDistricts = [];
  List<model.ProvinceinTh> _zipCode = [];
  model.ProvinceinTh? _selectedProvince;
  model.ProvinceinTh? _selectedDistrict;
  model.ProvinceinTh? _selectedSubDistrict;
  model.ProvinceinTh? _selectZipCode;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _provincesFuture = fetchProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 556,
            padding: EdgeInsets.all(16),
            child: FutureBuilder<List<model.ProvinceinTh>>(
              future: _provincesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.asset(
                        "assets/animation/Animation - 1723570737186.json"),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                List<model.ProvinceinTh> provinces = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "เพิ่มข้อมูลที่อยู่",
                      style: TextStyle(
                        fontFamily: "Prompt",
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<model.ProvinceinTh>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text("จังหวัด"),
                          labelStyle: TextStyle(
                              fontFamily: "Prompt", color: Colors.black)),
                      borderRadius: BorderRadius.circular(20),
                      isExpanded: true,
                      value: _selectedProvince,
                      items: provinces.map((province) {
                        return DropdownMenuItem<model.ProvinceinTh>(
                          value: province,
                          child: Text(
                            province.nameTh,
                            style: TextStyle(
                                fontFamily: "Prompt", color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProvince = newValue;
                          _selectedDistrict = null;
                          _selectedSubDistrict = null;
                          _districts = newValue?.amphure ?? [];
                          _subDistricts = [];
                        });
                        log('Selected Province: ${newValue?.nameTh}');
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<model.ProvinceinTh>(
                      isExpanded: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text("อำเภอ"),
                          labelStyle: TextStyle(
                              fontFamily: "Prompt", color: Colors.black)),
                      value: _selectedDistrict,
                      items: _districts.map((district) {
                        return DropdownMenuItem<model.ProvinceinTh>(
                          value: district,
                          child: Text(
                            district.nameTh,
                            style: TextStyle(
                                fontFamily: "Prompt", color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDistrict = newValue;
                          _selectedSubDistrict = null;
                          _subDistricts = newValue?.tambon ?? [];
                        });
                        log('Selected Province: ${newValue?.nameTh}');
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<model.ProvinceinTh>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text("ตำบล"),
                          labelStyle: TextStyle(
                              fontFamily: "Prompt", color: Colors.black)),
                      isExpanded: true,
                      value: _selectedSubDistrict,
                      items: _subDistricts.map((subDistrict) {
                        return DropdownMenuItem<model.ProvinceinTh>(
                          value: subDistrict,
                          child: Text(
                            subDistrict.nameTh,
                            style: TextStyle(
                                fontFamily: "Prompt", color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSubDistrict = newValue;
                          _zipCode = _selectedSubDistrict != null
                              ? [
                                  newValue!
                                ] // Assuming each sub-district has one zip code
                              : [];
                          _selectZipCode =
                              _zipCode.isNotEmpty ? _zipCode.first : null;
                        });
                        log('Selected Sub-District: ${newValue?.nameTh}');
                      },
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: banLekte,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกบ้านเลขที่';
                          }
                          if (!RegExp(r'^[0-9]+(/[0-9]+)?[A-Za-z]?$')
                              .hasMatch(value)) {
                            return 'กรอกบ้านเลขที่เท่านั้น';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: "บ้านเลขที่",
                            labelStyle: TextStyle(
                                fontFamily: "Prompt", color: Colors.black)),
                      ),
                    ),
                    DropdownButtonFormField<model.ProvinceinTh>(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          label: Text("รหัสไปรสณีย์"),
                          labelStyle: TextStyle(
                              fontFamily: "Prompt", color: Colors.black)),
                      isExpanded: true,
                      value: _selectZipCode,
                      items: _zipCode.map((zipCode) {
                        return DropdownMenuItem<model.ProvinceinTh>(
                          value: zipCode,
                          child: Text(
                            zipCode.zipCode?.toString() ??
                                'ไม่มี', // Display the zip code here
                            style: TextStyle(
                                fontFamily: "Prompt", color: Colors.black),
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectZipCode = newValue;
                        });
                        log('Selected zipCode: ${newValue?.zipCode}');
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(a, r, g, b))),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              log("${widget.userID}");
                              if (_selectedProvince != null ||
                                  _selectedDistrict != null ||
                                  _selectedSubDistrict != null ||
                                  banLekte != null) {
                                addUserAdress();
                              } else {
                                Get.snackbar(
                                    "แจ้งเตือน", "ตรวจสอบข้อมูลของคุณ");
                              }
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "ยืนยัน",
                                style: TextStyle(
                                    fontFamily: "Prompt",
                                    color: Colors.black,
                                    fontSize: 20),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.black,
                              ),
                            ],
                          )),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> addUserAdress() async {
    final url = Uri.parse(
        "http://${IPGlobals}:5000/api/users/updateUserAddress"); // Replace with your machine's IP address
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      "users_address": "${banLekte.text} "
          "ต.${_selectedSubDistrict?.nameTh} "
          "อ.${_selectedDistrict?.nameTh} "
          "จ.${_selectedProvince?.nameTh} "
          "${_selectZipCode?.zipCode}",
      "user_id": widget.userID
    });

    final response = await http.put(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("${data}");
      Get.back(result: 1);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA");
    }
  }
}

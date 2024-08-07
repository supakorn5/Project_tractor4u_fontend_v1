import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:tractor4your/Start/Login.dart';
import 'package:tractor4your/Start/Register.dart';

String ip = '10.0.2.45';

//Login
Future<Map<String, dynamic>?> api_Login(
    TextEditingController users, TextEditingController password) async {
  final url = Uri.parse("http://" + ip + ":5000/api/users/LoginUsers");
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "users_username": users.text,
    "users_password": password.text,
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data['data']['users_id']);
    return data['data'];
  } else if (response.statusCode == 404 || response.statusCode == 401) {
    print("FAIL LOAD DATA");
    return {};
  } else {
    throw Exception("Failed to load data");
  }
}

//Register
Future<void> api_Register(
    TextEditingController users,
    TextEditingController password,
    TextEditingController phone,
    int userType,
    String img) async {
  final url = Uri.parse("http://" +
      ip +
      ":5000/api/users/register_users"); // Replace with your machine's IP address
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "users_username": users.text,
    "users_password": password.text,
    "users_phone": phone.text,
    "users_type": userType,
    "users_image": img.toString(),
  });

  final respone = await http.post(url, headers: headers, body: body);
  if (respone.statusCode == 200) {
    final data = jsonDecode(respone.body);
    print(data['message']);
  } else {
    final data = jsonDecode(respone.body);
    print(data['message']);
  }
}


//กดจองคิว
Future<void> api_Reserve(DateTime reserve_date, DateTime? start_date, int? lands_id, int? users_id, int owners_id) async {
  final url = Uri.parse("http://" + ip + ":5000/api/users/Reserve"); //My laptop
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "orders_reserve_date": DateFormat('yyyy-MM-dd').format(reserve_date),
    "orders_start_date": DateFormat('yyyy-MM-dd').format(start_date!),
    "orders_lands_id": lands_id,
    "orders_users_id": users_id,
    "orders_owners_id": owners_id
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final decodeResponse = jsonDecode(response.body);
    print('----------------reserve--------------');
    print(decodeResponse);
  } else if (response.statusCode == 404 || response.statusCode == 401) {
    print("FAIL LOAD DATA");
  }
}


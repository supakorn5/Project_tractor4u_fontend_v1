import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String ip = '10.0.2.6';

// Future<List<dynamic>> api_selectOwnerOpenFullInfo() async {
//   final url = Uri.parse("http://" +
//       ip +
//       ":5000/api/owners/GetOwnersOpenFullInfo"); // Update with your actual endpoint
//   final headers = {'Content-Type': 'application/json'};

//   final response = await http.post(url, headers: headers);
//   if (response.statusCode == 200) {
//     final decodeResponse = jsonDecode(response.body);
//     print(decodeResponse['data']);
//     return decodeResponse['data'];
//   } else if (response.statusCode == 404 || response.statusCode == 401) {
//     print("FAIL LOAD DATA");
//     return [];
//   } else {
//     throw Exception("Failed to load data");
//   }
// }
Future<List<dynamic>> api_selectOwnerOpenFullInfo() async {
  final url = Uri.parse("http://" +
      ip +
      ":5000/api/owners/GetOwnersOpenFullInfo"); // Update with your actual endpoint
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.post(url, headers: headers);
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      print(decodeResponse['data']);
      return decodeResponse['data'];
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print("FAIL LOAD DATA: ${response.statusCode} ${response.body}");
      return [];
    } else {
      print("Unexpected error: ${response.statusCode} ${response.body}");
      throw Exception("Failed to load data");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to load data");
  }
}

Future<List<dynamic>> api_getOwnerInfo(int? owners_id) async {
  final url =
      Uri.parse("http://" + ip + ":5000/api/owners/GetOwnersInfo"); //My laptop
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode({
    "owners_id": owners_id,
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final decodeResponse = jsonDecode(response.body);
    print(decodeResponse['data']);
    return decodeResponse['data'];
    // setState(() {
    //   ownersInfo = decodeResponse['data'];
    // });
  } else if (response.statusCode == 404 || response.statusCode == 401) {
    print("FAIL LOAD DATA");
    return [];
  } else {
    throw Exception("Failed to load data");
  }
}

// Future<List<dynamic>> api_getDateStatus(int owners_id) async {
//   final url = Uri.parse("http://" +
//       ip +
//       ":5000/api/users/GetDateStatus"); // Update with your actual endpoint
//   final headers = {'Content-Type': 'application/json'};

//   final body = jsonEncode({
//     "owners_id": owners_id,
//   });

//   final response = await http.post(url, headers: headers, body: body);
//   if (response.statusCode == 200) {
//     final decodeResponse = jsonDecode(response.body);
//     print('---------------this in api getDateStatus---------------');
//     print(decodeResponse['data']);
//     return decodeResponse['data'];
//   } else if (response.statusCode == 404 || response.statusCode == 401) {
//     print("FAIL LOAD DATA date status");
//     return [];
//   } else {
//     throw Exception("Failed to load data");
//   }
// }
Future<List<dynamic>> api_getDateStatus(int owners_id) async {
  final url = Uri.parse("http://" +
      ip +
      ":5000/api/users/GetDateStatus"); // Update with your actual endpoint
  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    "owners_id": owners_id,
  });

  try {
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final decodeResponse = jsonDecode(response.body);
      print('---------------this in api getDateStatus---------------');
      print(decodeResponse['data']);
      return decodeResponse['data'];
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      print(
          "FAIL LOAD DATA date status: ${response.statusCode} ${response.body}");
      return [];
    } else {
      print("Unexpected error: ${response.statusCode} ${response.body}");
      throw Exception("Failed to load data");
    }
  } catch (e) {
    print("Error: $e");
    throw Exception("Failed to load data");
  }
}

Future<List<dynamic>> api_getOrderByDate(
    int owners_id, DateTime selectedDay) async {
  final url = Uri.parse("http://" +
      ip +
      ":5000/api/users/GetOrderByDate"); // Update with your actual endpoint
  final headers = {'Content-Type': 'application/json'};

  final body = jsonEncode({
    "owners_id": owners_id,
    "start_date": DateFormat('yyyy-MM-dd').format(selectedDay)
  });

  final response = await http.post(url, headers: headers, body: body);
  if (response.statusCode == 200) {
    final decodeResponse = jsonDecode(response.body);
    print('---------------this in api getDateStatus---------------');
    print(decodeResponse['data']);
    return decodeResponse['data'];
  } else if (response.statusCode == 404 || response.statusCode == 401) {
    print("FAIL LOAD DATA");
    return [];
  } else {
    throw Exception("Failed to load data");
  }
}

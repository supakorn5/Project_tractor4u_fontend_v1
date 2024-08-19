import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tractor4your/model/orders/getdatestatus_id.dart';
import 'package:tractor4your/model/orders/getownerID.dart';
import 'package:tractor4your/model/orders/getqueuebydate.dart';
import 'package:tractor4your/model/orders/getdatestatus.dart';
import 'package:tractor4your/model/orders/getuserID.dart';
import '../../model/orders/getJobbyuser_id.dart';

String IP = "192.168.96.151";

class OrderService {
  final String apiUrl = 'http://${IP}:5000/api/orders/GetJobByUserId';
  final String apiUrl2 = 'http://${IP}:5000/api/orders/GetQueueByDate';
  final String apiUrl3 = "http://${IP}:5000/api/orders/GetOwnerID";
  final String apiUrl4 = "http://${IP}:5000/api/orders/GetDateStatus";
  final String apiUrl5 = "http://${IP}:5000/api/orders/GetDateStatus_ID";
  final String apiUrl6 = "http://${IP}:5000/api/orders/GetUserID";

  Future<GetJobbyuserId> fetchOrders(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return getJobbyuserIdFromJson(response.body);
    } else {
      throw Exception("FAILED");
    }
  }

  Future<GetQueueByDate> fetchQueue(String date, int id) async {
    final response = await http.get(Uri.parse('$apiUrl2/$date/$id'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return getQueueByDateFromJson(response.body);
    } else {
      throw Exception("FAILED");
    }
  }

  Future<GetOwnerId> fetchOwnerID(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl3/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Parse the JSON response into your data model
      return getOwnerIdFromJson(response.body);
    } else {
      throw Exception('Failed to load owner ID');
    }
  }

  Future<Getdatestatus> fetchdateStatus(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl4/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return Getdatestatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Fail to load DATE STATUS");
    }
  }

  Future<GetDateStatusId> fetchdateStatusID(String date, int id) async {
    final response = await http.get(Uri.parse('$apiUrl5/$date/$id'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return getDateStatusIdFromJson(response.body);
    } else {
      throw Exception("FAILED");
    }
  }

  Future<GetuserId> fetchuserID(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl6/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return getuserIdFromJson(response.body);
    } else {
      throw Exception("FAILED");
    }
  }
}

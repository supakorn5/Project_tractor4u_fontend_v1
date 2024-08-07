import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tractor4your/model/orders/getownerID.dart';
import 'package:tractor4your/model/orders/getqueuebydate.dart';
import 'package:tractor4your/model/orders/getdatestatus.dart';
import '../../model/orders/getordersbyuser_id.dart';

class OrderService {
  final String apiUrl = 'http://10.0.2.6:5000/api/orders/GetJobByUserId';
  final String apiUrl2 = 'http://10.0.2.6:5000/api/orders/GetQueueByDate';
  final String apiUrl3 = "http://10.0.2.6:5000/api/orders/GetOwnerID";
  final String apiUrl4 = "http://10.0.2.6:5000/api/orders/GetDateStatus";

  Future<GetOrdersByuserId> fetchOrders(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'), // Append the ID to the URL
      headers: {'Content-Type': 'application/json'},
    );

    return getOrdersByuserIdFromJson(response.body);
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

  Future<GetDateStatus> fetchDatestatus(int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl4/$id'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return GetDateStatus.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Fail to load DATE STATUS");
    }
  }
}

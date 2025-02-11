import 'package:http/http.dart' as http;
import 'dart:convert';
import 'customer_model.dart';

class CustomerService {
  static const String baseUrl = "http://localhost:8080/api";

  // ดึงข้อมูลลูกค้าทั้งหมด
  static Future<List<Customer>> fetchCustomers() async {
    final url = Uri.parse("$baseUrl/get/customer");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Customer.fromJsonList(data['data']);
    } else {
      throw Exception("Failed to load customers");
    }
  }

  // เพิ่มลูกค้า
  static Future<bool> addCustomer(Customer customer) async {
    final url = Uri.parse("$baseUrl/add/customer");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(customer.toJson()),
    );

    return _handleResponse(response);
  }

  // ลบลูกค้า
  static Future<bool> deleteCustomer(String cId) async {
    final url = Uri.parse("$baseUrl/del/customer");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode({"c_id": cId}),
    );

    return _handleResponse(response);
  }

  // แก้ไขข้อมูลลูกค้า
  static Future<bool> editCustomer(Customer customer) async {
    final url = Uri.parse("$baseUrl/edit/customer");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(customer.toJson()),
    );

    return _handleResponse(response);
  }

  // ตรวจสอบ response และคืนค่าเป็น true/false ตามค่า stats
  static bool _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['code'] == 200; // API ส่ง stats = 1 หมายถึงสำเร็จ
    }
    return false;
  }
}

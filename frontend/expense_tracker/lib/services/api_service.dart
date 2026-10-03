import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/expense.dart';


class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000";


  static Future<List<Expense>> getExpenses() async {
    final response = await http.get(
      Uri.parse("$baseUrl/expenses"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((json) => Expense.fromJson(json))
          .toList();
    }

    throw Exception("Failed to load expenses");
  }


  static Future<void> addExpense(
      Expense expense) async {

    final response = await http.post(
      Uri.parse("$baseUrl/expenses"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode(
        expense.toJson(),
      ),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add expense");
    }
  }


  static Future<void> deleteExpense(
      int id) async {

    final response = await http.delete(
      Uri.parse("$baseUrl/expenses/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete expense");
    }
  }
}
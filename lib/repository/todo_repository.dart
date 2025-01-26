import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:todo_app/model/todo_model.dart';

class TodoRepository {
  final String baseUrl = 'https://api.nstack.in/v1/todos';
  final Logger _logger = Logger();
  Future<List<Item>> getTodos() async {
    final response = await http.get(Uri.parse('$baseUrl?page=1&limit=10'));

    _logger.d('API Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final Welcome welcome = Welcome.fromJson(jsonResponse);
      return welcome.items;
    } else {
      throw Exception('Failed to fetch todos');
    }
  }

  Future<Item> addTodo(Item item) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(item.toJson()),
    );
    _logger.d('API Response: ${response.body}');

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      _logger.d('Decoded JSON Response: $jsonResponse');

      return Item.fromJson(jsonResponse);
    } else {
      _logger.e(
          'Failed to add todo. Status Code: ${response.statusCode}, Body: ${response.body}');
      throw Exception('Failed to add todo: ${response.body}');
    }
  }

  Future<void> updateTodo(String id, Item updatedTodo) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedTodo.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception(
            'Failed to delete todo: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      _logger.e('Failed to delete todo: $id', error: e);
      rethrow;
    }
  }
}

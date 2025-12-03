import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/activity_model.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000/api';

  Future<List<ActivityModel>> getActivities() async {
    final response = await http.get(Uri.parse('$_baseUrl/activities'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => ActivityModel.fromJson(json)).toList();
    }
    throw Exception('Failed to load activities');
  }

  Future<ActivityModel> createActivity({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    File? imageFile,
  }) async {
    final uri = Uri.parse('$_baseUrl/activities');
    final request = http.MultipartRequest('POST', uri);

    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    request.fields['timestamp'] = timestamp.toIso8601String();

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return ActivityModel.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to create activity');
  }

  Future<void> deleteActivity(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/activities/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete activity');
    }
  }
}

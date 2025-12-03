import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_model.dart';

class StorageService {
  static const String _boxName = 'smarttracker_cache';
  static Box? _box;  // ← Hive uses Box<dynamic> internally

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);  // ← No generic needed
  }

  static Future<void> saveRecent(List<ActivityModel> activities) async {
    if (_box == null) return;

    // ✅ Hive accepts List<Map<String, dynamic>> directly
    final List<Map<String, dynamic>> jsonList =
    activities.map((activity) => activity.toJson()).toList();

    await _box!.put('recent_activities', jsonList);
  }

  static Future<List<ActivityModel>> getRecent() async {
    if (_box == null) return [];

    final rawData = _box!.get('recent_activities', defaultValue: []);

    if (rawData == null || rawData.isEmpty) return [];

    // ✅ Safe casting for Hive dynamic data
    return (rawData as List<dynamic>)
        .map((json) => ActivityModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

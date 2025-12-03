import 'dart:io';
import '../models/activity_model.dart';
import '../data/api_service.dart';
import '../utils/storage_service.dart';

class ActivityRepository {
  final ApiService _apiService = ApiService();

  Future<List<ActivityModel>> fetchActivities() async {
    try {
      final remoteActivities = await _apiService.getActivities();
      await StorageService.saveRecent(remoteActivities.take(5).toList());
      return remoteActivities;
    } catch (e) {
      return await StorageService.getRecent();
    }
  }

  Future<ActivityModel> addActivity({
    required double latitude,
    required double longitude,
    required DateTime timestamp,
    File? imageFile,
  }) async {
    final createdActivity = await _apiService.createActivity(
      latitude: latitude,
      longitude: longitude,
      timestamp: timestamp,
      imageFile: imageFile,
    );

    final cached = await StorageService.getRecent();
    cached.insert(0, createdActivity);
    if (cached.length > 5) cached.removeLast();
    await StorageService.saveRecent(cached);

    return createdActivity;
  }

  Future<void> deleteActivity(int id) async {
    await _apiService.deleteActivity(id);

    final cached = await StorageService.getRecent();
    final updatedCache = cached.where((activity) => activity.id != id).toList();
    await StorageService.saveRecent(updatedCache);
  }
}

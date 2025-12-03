import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/activity_repository.dart';
import '../models/activity_model.dart';

class ActivityProvider extends ChangeNotifier {
  final ActivityRepository _repository = ActivityRepository();

  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _error;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadActivities() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _activities = await _repository.fetchActivities();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addActivity({
    required double latitude,
    required double longitude,
    File? imageFile,
  }) async {
    try {
      final newActivity = await _repository.addActivity(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        imageFile: imageFile,
      );
      _activities.insert(0, newActivity);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteActivity(int id) async {
    try {
      await _repository.deleteActivity(id);
      _activities.removeWhere((activity) => activity.id == id);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

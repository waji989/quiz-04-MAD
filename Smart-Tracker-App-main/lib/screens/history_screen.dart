import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/activity_provider.dart';
import '../widgets/activity_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity History')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search activities...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: Consumer<ActivityProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredActivities = provider.activities.where((activity) {
                  final searchTerm = _searchController.text.toLowerCase();
                  return activity.timestamp
                      .toLocal()
                      .toString()
                      .toLowerCase()
                      .contains(searchTerm) ||
                      '${activity.latitude},${activity.longitude}'
                          .contains(searchTerm);
                }).toList();

                if (filteredActivities.isEmpty) {
                  return const Center(
                    child: Text('No activities found'),
                  );
                }

                return ListView.builder(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filteredActivities.length,
                  itemBuilder: (context, index) {
                    final activity = filteredActivities[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ActivityTile(
                        activity: activity,
                        onTap: () {
                          // Optional: open details or map screen
                        },
                        onDelete: () {
                          if (activity.id != null) {
                            provider.deleteActivity(activity.id!);
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

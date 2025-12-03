import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class ActivityTile extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const ActivityTile({
    super.key,
    required this.activity,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: activity.imageUrl != null
                    ? Image.network(
                  'http://10.0.2.2:3000${activity.imageUrl}',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
                )
                    : Container(
                  width: 60,
                  height: 60,
                  color: cs.primary.withOpacity(0.08),
                  child: Icon(
                    Icons.location_on,
                    color: cs.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lat: ${activity.latitude.toStringAsFixed(4)}, '
                          'Lng: ${activity.longitude.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.timestamp
                          .toLocal()
                          .toString()
                          .substring(0, 19),
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: cs.error,
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

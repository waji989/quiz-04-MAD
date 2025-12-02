// home_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'capture_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<bool> _cardVisible = List<bool>.filled(4, false);
  bool _headerVisible = false;

  @override
  void initState() {
    super.initState();

    // Smooth stagger animation
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _headerVisible = true);
    });

    for (var i = 0; i < _cardVisible.length; i++) {
      Future.delayed(Duration(milliseconds: 300 + i * 110), () {
        if (mounted) setState(() => _cardVisible[i] = true);
      });
    }
  }

  void _onNavTap(int idx) {
    setState(() => _selectedIndex = idx);
    if (idx == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const MapScreen()));
    } else if (idx == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Smart Tracker'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),

      // FAB → (no Hero to avoid the crash)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CaptureScreen()),
        ),
        label: const Text('Capture'),
        icon: const Icon(Icons.camera_alt_outlined),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
        showUnselectedLabels: true,
        selectedItemColor: cs.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),

      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withOpacity(0.15),
                  cs.primaryContainer.withOpacity(0.05),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Animated header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: _headerVisible ? 1.0 : 0.0,
              child: _buildHeader(context, cs),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 130, 18, 0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SearchBar(),
                    const SizedBox(height: 20),

                    /// CARDS — Stagger Animation
                    _buildCardRow(0, 1),
                    const SizedBox(height: 12),
                    _buildCardRow(2, 3),

                    const SizedBox(height: 22),
                    _buildStatsRow(context),

                    const SizedBox(height: 28),
                    _buildRecentActivitiesHeader(context),

                    const SizedBox(height: 10),
                    const _RecentActivityItem(
                      title: 'Park Survey',
                      subtitle: 'Image saved • 2.3 km • 28 Nov',
                      icon: Icons.photo_camera,
                    ),
                    SizedBox(height: 8),
                    const _RecentActivityItem(
                      title: 'Road Checkpoint',
                      subtitle: 'Coordinates logged • 1.1 km • 25 Nov',
                      icon: Icons.location_on,
                    ),
                    SizedBox(height: 8),
                    const _RecentActivityItem(
                      title: 'Boundary Capture',
                      subtitle: 'Image saved • 4.8 km • 12 Nov',
                      icon: Icons.landscape,
                    ),

                    const SizedBox(height: 90),
                    Center(
                      child: Text(
                        'Made by Wajahat Ali Khan',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------- HEADER UI ---------------
  Widget _buildHeader(BuildContext context, ColorScheme cs) {
    return Container(
      height: 155,
      padding: const EdgeInsets.fromLTRB(18, 34, 18, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.secondary.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.18),
            child: const Icon(Icons.person, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Wajahat Ali Khan',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ready to track & capture today?',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white.withOpacity(0.95)),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.18),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapScreen()),
            ),
            icon: const Icon(Icons.navigation_rounded, color: Colors.white),
            label: const Text('Map', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  // ---------- SMALL HELPERS -------------

  Widget _buildCardRow(int i1, int i2) {
    return Row(
      children: [
        Expanded(child: _animatedCard(i1)),
        const SizedBox(width: 12),
        Expanded(child: _animatedCard(i2)),
      ],
    );
  }

  Widget _animatedCard(int index) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 420),
      opacity: _cardVisible[index] ? 1 : 0,
      child: Transform.translate(
        offset: Offset(_cardVisible[index] ? 0 : 18, 0),
        child: _ActionCard(
          label: _cardLabels[index],
          subtitle: _cardSubtitles[index],
          icon: _cardIcons[index],
          onTap: _cardActions[index](context),
        ),
      ),
    );
  }

  final List<String> _cardLabels = const [
    'Live Tracking', 'Capture', 'History', 'Summary'
  ];

  final List<String> _cardSubtitles = const [
    'Real-time map and route',
    'Photo & location log',
    'All saved activities',
    'Weekly stats & routes'
  ];

  final List<IconData> _cardIcons = const [
    Icons.map_outlined,
    Icons.camera_alt_outlined,
    Icons.history_toggle_off,
    Icons.bar_chart_rounded
  ];

  late final List<Function> _cardActions = [
        (ctx) => () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const MapScreen())),
        (ctx) => () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CaptureScreen())),
        (ctx) => () => Navigator.push(ctx, MaterialPageRoute(builder: (_) => const HistoryScreen())),
        (ctx) => () {},
  ];

  Widget _buildStatsRow(BuildContext context) {
    double w = (MediaQuery.of(context).size.width - 54) / 3;
    return Row(
      children: [
        _StatTile(title: '12', subtitle: 'Activities', width: w),
        const SizedBox(width: 12),
        _StatTile(title: '3.2 km', subtitle: 'Avg. distance', width: w),
        const SizedBox(width: 12),
        _StatTile(title: 'Today', subtitle: 'Last update', width: w),
      ],
    );
  }

  Widget _buildRecentActivitiesHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Recent activities',
          style:
          Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('See all'),
        )
      ],
    );
  }
}

// ------------------------------------
// --- Small reusable widgets ---------
// ------------------------------------

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search activities, locations...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.primaryContainer.withOpacity(0.45),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: cs.primary),
            const SizedBox(height: 12),
            Text(label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                )),
            const SizedBox(height: 4),
            Text(subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.65),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final double width;

  const _StatTile({
    required this.title,
    required this.subtitle,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _RecentActivityItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _RecentActivityItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: cs.primary, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

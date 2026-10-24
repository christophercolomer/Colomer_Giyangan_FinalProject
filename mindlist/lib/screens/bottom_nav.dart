import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'task_list_screen.dart';
import 'forecast_screen.dart';

class BottomNav extends StatefulWidget {
  final int initialIndex;
  const BottomNav({super.key, this.initialIndex = 0});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late int _index = widget.initialIndex;

  static const _tabs = [HomeScreen(), TaskListScreen(), ForecastScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
          NavigationDestination(
            icon: Icon(Icons.cloud_outlined),
            selectedIcon: Icon(Icons.cloud),
            label: 'Forecast',
          ),
        ],
      ),
    );
  }
}

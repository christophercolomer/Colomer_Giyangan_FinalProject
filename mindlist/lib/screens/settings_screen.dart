import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/location.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _pickLocation(BuildContext context) {
    final settings = context.read<SettingsProvider>();

    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final city in philippineCities)
              ListTile(
                title: Text(city.name),
                trailing:
                    city == settings.location ? const Icon(Icons.check) : null,
                onTap: () {
                  settings.setLocation(city);
                  Navigator.pop(sheetContext);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: const Text('Location'),
            subtitle: Text(settings.location.name),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pickLocation(context),
          ),
          SwitchListTile(
            secondary: Icon(settings.isDark ? Icons.dark_mode : Icons.light_mode),
            title: const Text('Dark mode'),
            value: settings.isDark,
            onChanged: settings.setDark,
          ),
        ],
      ),
    );
  }
}
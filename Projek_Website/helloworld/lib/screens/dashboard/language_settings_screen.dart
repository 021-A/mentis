// lib/screens/dashboard/language_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _selected = 'system'; // 'system' | 'en' | 'id'

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _selected = prefs.getString('app_language') ?? 'system');
  }

  Future<void> _save(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_language', value);
    if (mounted) Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: RadioGroup<String>(
          groupValue: _selected,
          onChanged: (String? value) {
            if (value == null) return;
            setState(() => _selected = value);
          },
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'system',
                title: const Text('System default'),
                subtitle: const Text('Use device language settings'),
              ),
              RadioListTile<String>(
                value: 'en',
                title: const Text('English'),
              ),
              RadioListTile<String>(
                value: 'id',
                title: const Text('Bahasa Indonesia'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  onPressed: () => _save(_selected),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

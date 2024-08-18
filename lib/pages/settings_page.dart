import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import '../main.dart';
import 'models/settings_page_model.dart';
export 'models/settings_page_model.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key, required this.parentState});
  State parentState;

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late SettingsPageModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsPageModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text(
                'Choose your app preferences.',
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0,
                ),
              ),
            ),
            buildSwitchListTile(
              title: 'Push Notifications',
              subtitle: 'Receive Push notifications from our application.',
              value: Main.isPushNotifications,
              onChanged: (newValue) async {
                Main.isPushNotifications = newValue;
                await Main.writeAllPrefs();
                setState(() {
                  _model.setSwitchListTileValue1(newValue);
                });
              },
            ),
            buildSwitchListTile(
              title: 'Email Notifications',
              subtitle: 'Receive email notifications from our marketing team about new features.',
              value: _model.switchListTileValue2,
              onChanged: (newValue) {
                setState(() {
                  _model.setSwitchListTileValue2(newValue);
                });
              },
            ),
            buildSwitchListTile(
              title: 'Dark Mode',
              subtitle: 'Enable Dark Mode for reduced eye strain and battery conservation.',
              value: Main.isDarkMode,
              onChanged: (newValue) async {
                _model.setSwitchListTileValue4(newValue);
                Main.isDarkMode = newValue;
                await Main.writeAllPrefs();
                setState(() {
                  MyAppState.currentState?.setState(() {});
                  widget.parentState.setState(() {});
                });
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: FFButtonWidget(
          onPressed: () {
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.of(context).pop();
            });
          },
          text: 'Save Changes',
          options: FFButtonOptions(
            width: 190,
            height: 50,
            color: const Color(0xCFF37F3A),
            textStyle: const TextStyle(
              fontFamily: 'Readex Pro',
              color: Colors.white,
              letterSpacing: 0,
            ),
            elevation: 3,
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget buildSwitchListTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Readex Pro',
            letterSpacing: 0,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Readex Pro',
            color: Color(0xFF8B97A2),
            letterSpacing: 0,
          ),
        ),
        tileColor: null,
        activeColor: Colors.white,
        trackColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return states.contains(MaterialState.selected) ? Color(0xCFF37F3A) : Colors.transparent;
          },
        ),
        dense: false,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

}

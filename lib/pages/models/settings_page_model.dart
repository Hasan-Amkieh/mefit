import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:me_fit/pages/settings_page.dart' show SettingsPage;
import 'package:flutter/material.dart';

class SettingsPageModel extends ChangeNotifier {
  // State fields for SwitchListTile widgets.
  bool _switchListTileValue1 = true;
  bool _switchListTileValue2 = true;
  bool _switchListTileValue3 = true;
  bool _switchListTileValue4 = true;

  // Getters for SwitchListTile values.
  bool get switchListTileValue1 => _switchListTileValue1;
  bool get switchListTileValue2 => _switchListTileValue2;
  bool get switchListTileValue3 => _switchListTileValue3;
  bool get switchListTileValue4 => _switchListTileValue4;

  // Setters for SwitchListTile values.
  void setSwitchListTileValue1(bool value) {
    _switchListTileValue1 = value;
    notifyListeners();
  }

  void setSwitchListTileValue2(bool value) {
    _switchListTileValue2 = value;
    notifyListeners();
  }

  void setSwitchListTileValue3(bool value) {
    _switchListTileValue3 = value;
    notifyListeners();
  }

  void setSwitchListTileValue4(bool value) {
    _switchListTileValue4 = value;
    notifyListeners();
  }
}

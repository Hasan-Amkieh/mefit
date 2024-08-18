import 'package:flutterflow_ui/flutterflow_ui.dart';
import '../grocery_product_page.dart' show GroceryProductPage;
import 'package:flutter/material.dart';

class FoodCriticsModel extends FlutterFlowModel<GroceryProductPage> {

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

import 'package:flutter_svg/svg.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:me_fit/utilities/product.dart';

import '../controllers/theme_controller.dart';
import 'models/grocery_product_model.dart';
export 'models/grocery_product_model.dart';

class GroceryProductPage extends StatefulWidget {
  GroceryProductPage({super.key, required this.product});
  Product product;

  @override
  State<GroceryProductPage> createState() => _FoodCriticsWidgetState();
}

class _FoodCriticsWidgetState extends State<GroceryProductPage> {
  late FoodCriticsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodCriticsModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FlutterFlowIconButton(
                          borderColor:
                          FlutterFlowTheme.of(context).secondaryText,
                          borderRadius: 20,
                          borderWidth: 1,
                          buttonSize: 40,
                          fillColor: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                          icon: Icon(
                            Icons.chevron_left_sharp,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(90, 0, 0, 0),
                            child: Text(
                              'Food Analytics',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                fontFamily: 'Outfit',
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.product.imageURL.isNotEmpty ? Image.network(widget.product.imageURL, height: 150) : SvgPicture.asset("assets/images/packaging.svg", height: 150, color: Colors.white),
                    ),
                    SizedBox(height: 0.05 * MediaQuery.of(context).size.height),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                      child: Text(
                              widget.product.name, style: ThemeController.getTitleMediumFont().override(
                                fontFamily: 'Readex Pro', color: ThemeController.getPrimaryTextColor()
                              ),
                              textAlign: TextAlign.center
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 12,),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.zero,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.product.brands,
                                style: ThemeController.getBodyMediumFont(), textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            const SizedBox(height: 8),
                            DataTable(
                              dividerThickness: 0.0,
                              columnSpacing: 50,
                              headingRowHeight: 0,
                              dataRowMaxHeight: 50,
                              columns: const [
                                DataColumn(label: SizedBox(width: 0, height: 0)),
                                DataColumn(label: SizedBox(width: 0, height: 0)),
                              ],
                              rows: widget.product.ingredients.entries.map((entry) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(entry.key, style: TextStyle(color: ThemeController.getPrimaryTextColor(), fontSize: 15))),
                                    DataCell(Text(entry.value, style: TextStyle(color: ThemeController.getPrimaryTextColor(), fontSize: 15))),
                                  ],
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

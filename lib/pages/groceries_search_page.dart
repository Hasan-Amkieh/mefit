import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:me_fit/pages/grocery_product_page.dart';

import '../controllers/theme_controller.dart';
import '../utilities/product.dart';
import 'models/groceries_search_page_model.dart';
export 'models/groceries_search_page_model.dart';

import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:http/http.dart' as http;

class GroceriesSearchPage extends StatefulWidget {
  const GroceriesSearchPage({super.key});

  @override
  State<GroceriesSearchPage> createState() => GroceriesSearchPageState();
}

class GroceriesSearchPageState extends State<GroceriesSearchPage> {
  late GroceriesSearchPageModel model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<Product> foundProducts = [];
  String oldText = "";
  int lastRequestMadeMillis = 0;
  String scanBarcode = "Unknown";

  @override
  void initState() {
    super.initState();
    model = createModel(context, () => GroceriesSearchPageModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {});

    model.textController ??= TextEditingController();
    model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    model.dispose();

    super.dispose();
  }

  Future<Product?> searchByBarcode(String barcode) async {
    http.Response response = await http.get(Uri.parse("https://world.openfoodfacts.net/api/v2/product/$barcode?fields=product_name"));
    if (response.statusCode == 200 && response.body.contains("\"status_verbose\":\"product found\"")) { // then the barcode does exist, request the information:
      try {
        response = await http.get(Uri.parse("https://world.openfoodfacts.net/api/v2/product/$barcode")).timeout(const Duration(seconds: 8));
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        Map<String, String> ingrs = {};
        (jsonData['product']['nutriments'] as Map<String, dynamic>).forEach((key, value_) {
          if (key.endsWith("_unit")) {
            ingrs.update(key.split("_unit")[0], (value) => "$value $value_", ifAbsent: () => " $value_");
          } else if (key.endsWith("_value")) {
            ingrs.update(key.split("_value")[0], (value) => "$value_$value", ifAbsent: () => "$value_");
          }
        });

        Product product = Product(name: jsonData['product']['product_name'] ?? "", brands: jsonData['product']['brands'] ?? "", quantity: jsonData['product']['quantity'] ?? "",
            code: barcode, countriesSold: jsonData['product']['countries'] ?? "", ingredients: ingrs,
            imageURL: jsonData['product']['image_front_small_url'] ?? "", categories: jsonData['product']['categories'] ?? "");
        return product;
      } on TimeoutException {
        // print("Timeout Error!!!\nTrying again!");
        await searchByBarcode(barcode);
      }
    } else {
      // print("The product is not found!");
      setState(() {
        foundProducts = [];
      });
    }
    return null;
  }

  Future<void> searchByName(String value) async {
    try {
      int requestMadeAt = DateTime.now().millisecondsSinceEpoch;
      lastRequestMadeMillis = requestMadeAt;
      http.Response response = await http.get(
          Uri.parse("https://world.openfoodfacts.org/cgi/search.pl?search_terms=${value.replaceAll(' ', '+')}&search_simple=1&action=process"))
          .timeout(const Duration(seconds: 8));
      if (requestMadeAt != lastRequestMadeMillis) {
        // print("Discarding request as a newer request has been made!");
        return ;
      }

      if (response.statusCode == 200) {
        print("Response Length: ${response.contentLength} of text $value");

        // process all the data
        List<String> foundBarcodes = [];
        int index = 0;
        const String specialString = '<a href="/product/';
        while (true) {
          index = response.body.indexOf(specialString, index);
          if (index == -1 ) {
            break;
          }
          foundBarcodes.add(response.body.substring(index + specialString.length, response.body.indexOf('/', index + specialString.length)));
          index = index + specialString.length;
        }
        // Load all the info about the barcodes and update the screen:
        List<bool> requests = [];
        for (int i = 0 ; i < foundBarcodes.length ; i++) {
          requests.add(false);
          searchByBarcode(foundBarcodes[i]).then((Product? product) {
            requests[i] = true;
            if (product != null) {
              foundProducts.add(product);
            }
          });
        }
        while (true) {
          await Future.delayed(const Duration(milliseconds: 50));
          ;
          bool break_ = true;
          for (int i = 0 ; i < foundBarcodes.length ; i++) {
            if (requests[i] == false) {
              break_ = false;
              continue;
            }
          }
          if (break_ == false) {
            continue;
          }
          break;
        }
        // all the products are loaded, update the screen:
        setState(() {});
      } else {
        // print("Could not search by name, status code ${response.statusCode}");
      }
    } on TimeoutException {
      // print("Timeout Error!!!\nTrying again!");
      await searchByName(value);
    }

  }

  Future<void> updateList(String value) async {

    if (RegExp(r'^[0-9]+$').hasMatch(value)) { // then it is a barcode number:
      Product? product = await searchByBarcode(value);
      if (product != null) {
        setState(() {
          foundProducts = [product];
        });
      }
    } else {
      foundProducts = [];
      searchByName(value);
    }

  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      // print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: ThemeController.getPrimaryBackgroundColor(),
        appBar: AppBar(
          backgroundColor: ThemeController.getSecondaryBackgroundColor(),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: ThemeController.getPrimaryTextColor(),
              size: 30,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: ThemeController.getSecondaryBackgroundColor(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextFormField(
                          controller: model.textController,
                          focusNode: model.textFieldFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Product Name',
                            labelStyle: ThemeController.getLabelMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            hintStyle: ThemeController.getLabelMediumFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getAlternateColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getPrimaryColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getErrorColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedErrorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: ThemeController.getErrorColor(),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding:
                            const EdgeInsetsDirectional.fromSTEB(24, 16, 0, 16),
                          ),
                          style: ThemeController.getBodyMediumFont().override(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                          minLines: null,
                          onChanged: (newText) async {
                            oldText = newText;
                            await updateList(newText);
                          },
                          validator: model.textControllerValidator
                              .asValidator(context),
                        ),
                      ),
                    ),
                    FlutterFlowIconButton(
                      borderColor: const Color.fromRGBO(0, 0, 0, 0),
                      borderRadius: 20,
                      borderWidth: 1,
                      buttonSize: 40,
                      fillColor: ThemeController.getSecondaryBackgroundColor(),
                      icon: Icon(
                        Icons.clear,
                        color: ThemeController.getPrimaryTextColor(),
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          model.textController.text = "";
                          foundProducts = [];
                        });
                      },
                    ),
                    const SizedBox(width: 16,),
                    FlutterFlowIconButton(
                      borderColor: const Color.fromRGBO(0, 0, 0, 0),
                      borderRadius: 20,
                      borderWidth: 1,
                      buttonSize: 40,
                      fillColor: ThemeController.getSecondaryBackgroundColor(),
                      icon: Icon(
                        Icons.barcode_reader,
                        color: ThemeController.getPrimaryTextColor(),
                        size: 24,
                      ),
                      onPressed: () async {
                        await scanBarcodeNormal();
                        model.textController.text = scanBarcode;
                        updateList(scanBarcode).then((value) => setState(() {}));
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search results',
                      style: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
                    Text(
                      '${foundProducts.length}',
                      style: ThemeController.getBodyMediumFont().override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: foundProducts.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: ThemeController.getSecondaryBackgroundColor(),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: foundProducts[index].imageURL.isNotEmpty ?
                                    Image.network(foundProducts[index].imageURL, width: 102) :
                                    SvgPicture.asset("assets/images/packaging.svg", width: 102, color: Colors.white),
                                  ),
                                  Expanded(
                                    child: ClipRect(
                                      clipBehavior: Clip.hardEdge,
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                10, 12, 0, 0),
                                            child: Text(
                                              foundProducts[index].name,
                                              softWrap: false,
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: ThemeController.getBodyMediumFont()
                                                  .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                20, 12, 0, 0),
                                            child: Flexible(
                                              child: Text(
                                                "${foundProducts[index].code}\n${foundProducts[index].countriesSold}",
                                                overflow: TextOverflow.ellipsis,
                                                style: ThemeController.getBodySmallFont()
                                                    .override(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (c, z, s) => GroceryProductPage(product: foundProducts[index])));
                        },
                      );
                    },
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

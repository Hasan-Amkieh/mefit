import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_fit/controllers/achievements_controller.dart';
import 'package:me_fit/controllers/theme_controller.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:me_fit/pages/chatbot_page.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'models/support_page_model.dart';
export 'models/support_page_model.dart';


class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}


class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => SupportPageState();
}

class SupportPageState extends State<SupportPage> {
  late SupportPageModel _model;

  late List<Item> _data;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 110),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 110),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 110),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 110),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation5': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 110),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation6': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: const Offset(0, 110),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SupportPageModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    loadDataFromCsv();
  }

  Future<void> loadDataFromCsv() async {
    String csvData = await rootBundle.loadString('assets/data/faq.csv');
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvData, shouldParseNumbers: false, textDelimiter: '"',  fieldDelimiter: ',', eol: '\n');
    List<Item> items = [];
    for (List<dynamic> row in rows) {
      items.add(Item(headerValue: row[0], expandedValue: row[1]));
    }
    setState(() {
      _data = items;
    });
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
        backgroundColor: ThemeController.getSecondaryBackgroundColor(),
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
          title: Text(
            'Get support',
            style: ThemeController.getTitleLargeFont().override(
              fontFamily: 'Outfit',
              letterSpacing: 0,
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/MeFit_Icon.png',
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to support',
                          style: ThemeController.getLabelLargeFont().override(
                            fontFamily: 'Readex Pro',
                            letterSpacing: 0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            'How can we help you?',
                            style: ThemeController.getHeadlineMediumFont()
                                .override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  //hasan please fill this
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ThemeController.getSecondaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ThemeController.getAlternateColor(),
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.web,
                                            color: Color(0xCFF37F3A),
                                            size: 36,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                            child: Text(
                                              'Our Website',
                                              textAlign: TextAlign.center,
                                              style: ThemeController.getBodyMediumFont()
                                                  .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation1']!),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final url = Uri.parse('mailto:mefit.ad1@gmail.com?subject=Support');
                                  if (await canLaunch(url.toString())) {
                                  await launch(url.toString());
                                  } else {
                                  throw 'Could not launch $url';
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ThemeController.getSecondaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ThemeController.getAlternateColor(),
                                        width: 2,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.email_outlined,
                                            color: Color(0xCFF37F3A),
                                            size: 36,
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                            child: Text(
                                              'Email Us',
                                              textAlign: TextAlign.center,
                                              style: ThemeController.getBodyMediumFont()
                                                  .override(
                                                fontFamily: 'Readex Pro',
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation1']!),
                                ),
                              ),
                            ),

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // Hasan please fill this
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ThemeController.getSecondaryBackgroundColor(),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: ThemeController.getAlternateColor(),
                                        width: 2,
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final url = Uri.parse('https://www.instagram.com/exercisewithmefit/');
                                        if (await canLaunch(url.toString())) {
                                          await launch(url.toString());
                                          if (Main.achievementsDates[32] == 0) {
                                            AchievementsController.completeAchievement(32);
                                          }
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.favorite_rounded,
                                              color: Color(0xCFF37F3A),
                                              size: 36,
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                                              child: Text(
                                                'Follow Us',
                                                textAlign: TextAlign.center,
                                                style: ThemeController.getBodyMediumFont()
                                                    .override(
                                                  fontFamily: 'Readex Pro',
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                  'containerOnPageLoadAnimation1']!),
                                ),
                              ),
                            ),
                          ].divide(const SizedBox(width: 12)),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                          child: Text(
                            'Review FAQ\'s below',
                            style: ThemeController.getLabelLargeFont()
                                .override(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                            ),
                          ),
                        ),

                        // Expansion Panel List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _data.length,
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              title: Text(_data[index].headerValue),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(_data[index].expandedValue),
                                ),
                              ],
                            );
                          },
                        )


                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 12),
                child: FFButtonWidget(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ChatBotPage()));
                  },
                  text: 'Chat Now',
                  icon: const FaIcon(
                    FontAwesomeIcons.robot,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48,
                    padding: const EdgeInsets.all(0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: const Color(0xCFF37F3A),
                    textStyle: ThemeController.getTitleSmallFont().override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                    elevation: 3,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

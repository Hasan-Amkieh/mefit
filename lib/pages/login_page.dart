import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_fit/controllers/database_controller.dart';
import 'package:me_fit/controllers/notification_controller.dart';
import 'package:me_fit/pages/fill_profile_info_page.dart';
import 'package:me_fit/pages/home_page.dart';

import 'package:me_fit/pages/models/login_page_model.dart';

import '../controllers/auth.dart';
import '../controllers/theme_controller.dart';
import '../main.dart';
export 'package:me_fit/pages/models/login_page_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  String errorMsgCreate = "";
  String errorMsgSignIn = "";

  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 1.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 400.ms,
          begin: const Offset(0, 80),
          end: const Offset(0, 0),
        ),
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 150.ms,
          duration: 400.ms,
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        ),
      ],
    ),
    'columnOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: const Offset(0, 20),
          end: const Offset(0, 0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        VisibilityEffect(duration: 300.ms),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 400.ms,
          begin: const Offset(0, 20),
          end: const Offset(0, 0),
        ),
      ],
    ),
  };

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(email: _model.emailAddressController.text,
          password: _model.passwordController.text);
      if (Auth().currentUser != null) {
        NotificationController.startReminders();
        await DatabaseController.readAllFields(Auth().currentUser!.email ?? '');
        Main.setLastActiveEmail(Auth().currentUser!.email ?? '');
        Main.initializeLocalDB();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsgSignIn = e.message ?? "";
      });
    }
  }

  Future<bool> showTermsAndPolicy() async {
    String policy = await rootBundle.loadString('assets/data/policy.txt');
    String terms = await rootBundle.loadString('assets/data/terms.txt');
    bool isAccepted = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text("Terms and Policy"),
          content: SingleChildScrollView(
            child: Text('$policy\n\n$terms'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Refuse'),
            ),
            TextButton(
              onPressed: () {
                isAccepted = true;
                Navigator.pop(context);
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );

    return isAccepted;
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (await showTermsAndPolicy()) {
      try {
        await Auth().createUserWithEmailAndPassword(email: _model.emailAddressCreateController.text,
            password: _model.passwordCreateController.text);
        if (Auth().currentUser != null) {
          NotificationController.startReminders();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const FillProfileInfoPage()));
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMsgCreate = e.message ?? "";
        });
      }
    }
  }

  Future<void> signInWithGoogle(bool isSignUp) async {
    if (isSignUp && ! await showTermsAndPolicy()) {
      return ;
    }

    try {
      await Auth().signInWithGoogle();
      if (Auth().currentUser != null) {
        NotificationController.startReminders();
        await DatabaseController.readAllFields(Auth().currentUser!.email ?? '');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => isSignUp ? const FillProfileInfoPage()
            : const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsgSignIn = e.message ?? "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    _model.emailAddressCreateController ??= TextEditingController();
    _model.emailAddressCreateFocusNode ??= FocusNode();

    _model.passwordCreateController ??= TextEditingController();
    _model.passwordCreateFocusNode ??= FocusNode();

    _model.emailAddressController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();

    _model.passwordController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(32, 0, 32, 0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/MeFit_Icon.png',
                      height: 100
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      child: Text(
                        'MeFit',
                        style: FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(0, -1),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.sizeOf(context).width >= 768.0
                                ? 530.0
                                : 630.0,
                            constraints: const BoxConstraints(
                              maxWidth: 570,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Color(0x33000000),
                                  offset: Offset(
                                    0,
                                    2,
                                  ),
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                width: 2,
                              ),
                            ),
                            child: Padding(
                              padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: const Alignment(0, 0),
                                    child: TabBar(
                                      isScrollable: true,
                                      labelColor: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      unselectedLabelColor:
                                      FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      labelPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          32, 0, 32, 0),
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                      unselectedLabelStyle:
                                      FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                      ),
                                      indicatorColor:
                                      FlutterFlowTheme.of(context).primary,
                                      indicatorWeight: 3,
                                      tabs: const [
                                        Tab(
                                          text: 'Create Account',
                                        ),
                                        Tab(
                                          text: 'Log In',
                                        ),
                                      ],
                                      controller: _model.tabBarController,
                                      onTap: (i) async {
                                        [() async {}, () async {}][i]();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _model.tabBarController,
                                      children: [
                                        Align(
                                          alignment:
                                          const AlignmentDirectional(0, -1),
                                          child: Padding(
                                            padding:
                                            const EdgeInsetsDirectional.fromSTEB(
                                                24, 16, 24, 0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  if (responsiveVisibility(
                                                    context: context,
                                                    phone: false,
                                                    tablet: false,
                                                  ))
                                                    Container(
                                                      width: 230,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: ThemeController.getSecondaryBackgroundColor(),
                                                      ),
                                                    ),
                                                  Text(
                                                    'Create Account',
                                                    textAlign: TextAlign.start,
                                                    style: ThemeController.getHeadlineMediumFont()
                                                        .override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0, 4, 0, 24),
                                                    child: Text(
                                                      'Let\'s get started by filling out the form below.',
                                                      textAlign:
                                                      TextAlign.start,
                                                      style: ThemeController.getLabelMediumFont()
                                                          .override(
                                                        fontFamily:
                                                        'Readex Pro',
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 16),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .emailAddressCreateController,
                                                        focusNode: _model
                                                            .emailAddressCreateFocusNode,
                                                        autofocus: true,
                                                        autofillHints: const [
                                                          AutofillHints.email
                                                        ],
                                                        obscureText: false,
                                                        decoration:
                                                        InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle: ThemeController.getLabelLargeFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                          enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getAlternateColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius: BorderRadius
                                                                .circular(40),
                                                          ),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getPrimaryColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getErrorColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedErrorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getErrorColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          filled: true,
                                                          fillColor: ThemeController.getSecondaryBackgroundColor(),
                                                          contentPadding:
                                                          const EdgeInsets.all(
                                                              24),
                                                        ),
                                                        style: ThemeController.getBodyLargeFont()
                                                            .override(
                                                          fontFamily:
                                                          'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                        minLines: null,
                                                        keyboardType:
                                                        TextInputType
                                                            .emailAddress,
                                                        validator: _model
                                                            .emailAddressCreateControllerValidator
                                                            .asValidator(
                                                            context),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0, 0, 0, 16),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .passwordCreateController,
                                                        focusNode: _model
                                                            .passwordCreateFocusNode,
                                                        autofocus: true,
                                                        autofillHints: const [
                                                          AutofillHints.password
                                                        ],
                                                        obscureText: !_model
                                                            .passwordCreateVisibility,
                                                        decoration:
                                                        InputDecoration(
                                                          labelText: 'Password',
                                                          labelStyle: ThemeController.getLabelLargeFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                          enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getAlternateColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getPrimaryColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getErrorColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedErrorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getErrorColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          filled: true,
                                                          fillColor: ThemeController.getSecondaryBackgroundColor(),
                                                          contentPadding:
                                                          const EdgeInsets.all(
                                                              24),
                                                          suffixIcon: InkWell(
                                                            onTap: () =>
                                                                setState(
                                                                      () => _model
                                                                      .passwordCreateVisibility =
                                                                  !_model
                                                                      .passwordCreateVisibility,
                                                                ),
                                                            focusNode: FocusNode(
                                                                skipTraversal:
                                                                true),
                                                            child: Icon(
                                                              _model.passwordCreateVisibility
                                                                  ? Icons
                                                                  .visibility_outlined
                                                                  : Icons
                                                                  .visibility_off_outlined,
                                                              color: ThemeController.getSecondaryTextColor(),
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        style: ThemeController.getBodyLargeFont()
                                                            .override(
                                                          fontFamily:
                                                          'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                        minLines: null,
                                                        validator: _model
                                                            .passwordCreateControllerValidator
                                                            .asValidator(
                                                            context),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: errorMsgCreate.isNotEmpty,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
                                                      child: Text(
                                                        errorMsgCreate,
                                                        textAlign: TextAlign.center,
                                                        style: ThemeController.getTitleSmallFont().override(
                                                          fontFamily: 'Readex Pro',
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 0, 16),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          createUserWithEmailAndPassword();
                                                        },
                                                        text: 'Get Started',
                                                        options:
                                                        FFButtonOptions(
                                                          width: 230,
                                                          height: 52,
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 0),
                                                          iconPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 0),
                                                          color: ThemeController.getPrimaryColor(),
                                                          textStyle: ThemeController.getTitleSmallFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            color: Colors
                                                                .white,
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                          elevation: 3,
                                                          borderSide:
                                                          const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(40),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              16,
                                                              0,
                                                              16,
                                                              24),
                                                          child: Text(
                                                            'Or sign up with',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: ThemeController.getLabelMediumFont()
                                                                .override(
                                                              fontFamily:
                                                              'Readex Pro',
                                                              letterSpacing:
                                                              0,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 16),
                                                          child: Wrap(
                                                            spacing: 16,
                                                            runSpacing: 0,
                                                            alignment:
                                                            WrapAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                            direction:
                                                            Axis.horizontal,
                                                            runAlignment:
                                                            WrapAlignment
                                                                .center,
                                                            verticalDirection:
                                                            VerticalDirection
                                                                .down,
                                                            clipBehavior:
                                                            Clip.none,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsetsDirectional
                                                                    .fromSTEB(0, 0, 0, 16),
                                                                child:
                                                                FFButtonWidget(
                                                                  onPressed: () async {
                                                                    await signInWithGoogle(true);
                                                                  },
                                                                  text:
                                                                  'Continue with Google',
                                                                  icon: const FaIcon(
                                                                    FontAwesomeIcons.google,
                                                                    size: 20,
                                                                  ),
                                                                  options:
                                                                  FFButtonOptions(
                                                                    width: 230,
                                                                    height: 44,
                                                                    padding: const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    iconPadding:
                                                                    const EdgeInsetsDirectional.fromSTEB(
                                                                        0,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                    color: ThemeController.getSecondaryBackgroundColor(),
                                                                    textStyle: ThemeController.getBodyMediumFont()
                                                                        .override(
                                                                      fontFamily:
                                                                      'Readex Pro',
                                                                      letterSpacing:
                                                                      0,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                    ),
                                                                    elevation:
                                                                    0,
                                                                    borderSide:
                                                                    BorderSide(
                                                                      color: ThemeController.getAlternateColor(),
                                                                      width: 2,
                                                                    ),
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        40),
                                                                    hoverColor: ThemeController.getPrimaryBackgroundColor(),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                            'columnOnPageLoadAnimation1']!),
                                          ),
                                        ),
                                        Align(
                                          alignment: const AlignmentDirectional(0, -1),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                24, 16, 24, 0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  if (responsiveVisibility(
                                                    context: context,
                                                    phone: false,
                                                    tablet: false,
                                                  ))
                                                    Container(
                                                      width: 230,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: ThemeController.getSecondaryBackgroundColor(),
                                                      ),
                                                    ),
                                                  Text(
                                                    'Welcome Back',
                                                    textAlign: TextAlign.start,
                                                    style: ThemeController.getHeadlineMediumFont()
                                                        .override(
                                                      fontFamily: 'Outfit',
                                                      letterSpacing: 0,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0, 4, 0, 24),
                                                    child: Text(
                                                      'Fill out the information below in order to access your account.',
                                                      textAlign:
                                                      TextAlign.start,
                                                      style: ThemeController.getLabelMediumFont()
                                                          .override(
                                                        fontFamily:
                                                        'Readex Pro',
                                                        letterSpacing: 0,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0, 0, 0, 16),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .emailAddressController,
                                                        focusNode: _model
                                                            .emailAddressFocusNode,
                                                        autofocus: true,
                                                        autofillHints: const [
                                                          AutofillHints.email
                                                        ],
                                                        obscureText: false,
                                                        decoration:
                                                        InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle: ThemeController.getLabelLargeFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                          enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getPrimaryBackgroundColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getPrimaryBackgroundColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getAlternateColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedErrorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getAlternateColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          filled: true,
                                                          fillColor: ThemeController.getSecondaryBackgroundColor(),
                                                          contentPadding: const EdgeInsetsDirectional
                                                              .fromSTEB(24, 24, 0, 24),
                                                        ),
                                                        style: ThemeController.getBodyLargeFont()
                                                            .override(
                                                          fontFamily:
                                                          'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                        minLines: null,
                                                        keyboardType:
                                                        TextInputType
                                                            .emailAddress,
                                                        validator: _model
                                                            .emailAddressControllerValidator
                                                            .asValidator(
                                                            context),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(
                                                        0, 0, 0, 16),
                                                    child: SizedBox(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .passwordController,
                                                        focusNode: _model
                                                            .passwordFocusNode,
                                                        autofocus: true,
                                                        autofillHints: const [
                                                          AutofillHints.password
                                                        ],
                                                        obscureText: !_model
                                                            .passwordVisibility,
                                                        decoration:
                                                        InputDecoration(
                                                          labelText: 'Password',
                                                          labelStyle: ThemeController.getLabelLargeFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                          enabledBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getAlternateColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getPrimaryColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          errorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getErrorColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          focusedErrorBorder:
                                                          OutlineInputBorder(
                                                            borderSide:
                                                            BorderSide(
                                                              color: ThemeController.getErrorColor(),
                                                              width: 2,
                                                            ),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                40),
                                                          ),
                                                          filled: true,
                                                          fillColor: ThemeController.getSecondaryBackgroundColor(),
                                                          contentPadding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(24, 24, 0, 24),
                                                          suffixIcon: InkWell(
                                                            onTap: () =>
                                                                setState(
                                                                      () => _model
                                                                      .passwordVisibility =
                                                                  !_model
                                                                      .passwordVisibility,
                                                                ),
                                                            focusNode: FocusNode(
                                                                skipTraversal:
                                                                true),
                                                            child: Icon(
                                                              _model.passwordVisibility
                                                                  ? Icons
                                                                  .visibility_outlined
                                                                  : Icons
                                                                  .visibility_off_outlined,
                                                              color: ThemeController.getSecondaryTextColor(),
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        style: ThemeController.getBodyLargeFont()
                                                            .override(
                                                          fontFamily:
                                                          'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                        minLines: null,
                                                        validator: _model
                                                            .passwordControllerValidator
                                                            .asValidator(
                                                            context),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 0, 16),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          await signInWithEmailAndPassword();
                                                        },
                                                        text: 'Sign In',
                                                        options:
                                                        FFButtonOptions(
                                                          width: 230,
                                                          height: 52,
                                                          padding: const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 0),
                                                          iconPadding: const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 0),
                                                          color: ThemeController.getPrimaryColor(),
                                                          textStyle: ThemeController.getTitleSmallFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            color: Colors
                                                                .white,
                                                            letterSpacing:
                                                            0,
                                                          ),
                                                          elevation: 3,
                                                          borderSide: const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(40),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: errorMsgSignIn.isNotEmpty,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
                                                      child: Text(
                                                        errorMsgSignIn,
                                                        textAlign: TextAlign.center,
                                                        style: ThemeController.getTitleSmallFont().override(
                                                          fontFamily: 'Readex Pro',
                                                          color: Colors.red,
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: const AlignmentDirectional(
                                                        0, 0),
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(16, 0,
                                                          16, 24),
                                                      child: Text(
                                                        'Or sign in with',
                                                        textAlign:
                                                        TextAlign.center,
                                                        style: ThemeController.getLabelMediumFont()
                                                            .override(
                                                          fontFamily:
                                                          'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment: const AlignmentDirectional(
                                                        0, 0),
                                                    child: Wrap(
                                                      spacing: 16,
                                                      runSpacing: 0,
                                                      alignment:
                                                      WrapAlignment.center,
                                                      crossAxisAlignment:
                                                      WrapCrossAlignment
                                                          .center,
                                                      direction:
                                                      Axis.horizontal,
                                                      runAlignment:
                                                      WrapAlignment.center,
                                                      verticalDirection:
                                                      VerticalDirection
                                                          .down,
                                                      clipBehavior: Clip.none,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 16),
                                                          child: FFButtonWidget(
                                                            onPressed: () async {
                                                              await signInWithGoogle(false);
                                                            },
                                                            text:
                                                            'Continue with Google',
                                                            icon: const FaIcon(
                                                              FontAwesomeIcons
                                                                  .google,
                                                              size: 20,
                                                            ),
                                                            options:
                                                            FFButtonOptions(
                                                              width: 230,
                                                              height: 44,
                                                              padding: const EdgeInsetsDirectional
                                                                  .fromSTEB(0, 0, 0, 0),
                                                              iconPadding: const EdgeInsetsDirectional
                                                                  .fromSTEB(0, 0, 0, 0),
                                                              color: ThemeController.getSecondaryBackgroundColor(),
                                                              textStyle:
                                                              FlutterFlowTheme.of(
                                                                  context)
                                                                  .bodyMedium
                                                                  .override(
                                                                fontFamily:
                                                                'Readex Pro',
                                                                letterSpacing:
                                                                0,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                              ),
                                                              elevation: 0,
                                                              borderSide:
                                                              BorderSide(
                                                                color: ThemeController.getAlternateColor(),
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  40),
                                                              hoverColor: ThemeController.getPrimaryBackgroundColor(),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    const AlignmentDirectional(
                                                        0, 0),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          0, 0, 0, 16),
                                                      child: FFButtonWidget(
                                                        onPressed: () async {
                                                          ;
                                                        },
                                                        text:
                                                        'Forgot Password?',
                                                        options:
                                                        FFButtonOptions(
                                                          height: 44,
                                                          padding: const EdgeInsetsDirectional
                                                              .fromSTEB(32,
                                                              0, 32, 0),
                                                          iconPadding: const EdgeInsetsDirectional
                                                              .fromSTEB(0,
                                                              0, 0, 0),
                                                          color: ThemeController.getSecondaryBackgroundColor(),
                                                          textStyle: ThemeController.getBodyMediumFont()
                                                              .override(
                                                            fontFamily:
                                                            'Readex Pro',
                                                            letterSpacing:
                                                            0,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                          ),
                                                          elevation: 0,
                                                          borderSide:
                                                          BorderSide(
                                                            color: ThemeController.getSecondaryBackgroundColor(),
                                                            width: 2,
                                                          ),
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(40),
                                                          hoverColor: ThemeController.getPrimaryBackgroundColor(),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ).animateOnPageLoad(animationsMap[
                                            'columnOnPageLoadAnimation2']!),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation']!),
                        ),
                      ],
                    ),
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

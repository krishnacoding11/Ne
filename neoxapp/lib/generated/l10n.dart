// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Online calls and messaging made easy`
  String get onlineCallsAndMessagingMadeEasy {
    return Intl.message(
      'Online calls and messaging made easy',
      name: 'onlineCallsAndMessagingMadeEasy',
      desc: '',
      args: [],
    );
  }

  /// `We will provide all best call\nstreaming in one click`
  String get weWillProvideAllBestCallStreamingInOneClick {
    return Intl.message(
      'We will provide all best call\nstreaming in one click',
      name: 'weWillProvideAllBestCallStreamingInOneClick',
      desc: '',
      args: [],
    );
  }

  /// `Get started`
  String get getStarted {
    return Intl.message(
      'Get started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to get started`
  String get signInToGetStarted {
    return Intl.message(
      'Sign in to get started',
      name: 'signInToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Create now`
  String get createNow {
    return Intl.message(
      'Create now',
      name: 'createNow',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don’t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Email or username`
  String get emailOrUsername {
    return Intl.message(
      'Email or username',
      name: 'emailOrUsername',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Contact`
  String get contact {
    return Intl.message(
      'Contact',
      name: 'contact',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get message {
    return Intl.message(
      'Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get setting {
    return Intl.message(
      'Setting',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Add number`
  String get addNumber {
    return Intl.message(
      'Add number',
      name: 'addNumber',
      desc: '',
      args: [],
    );
  }

  /// `Send message`
  String get sendMessage {
    return Intl.message(
      'Send message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Brenda Garcia`
  String get brendaGarcia {
    return Intl.message(
      'Brenda Garcia',
      name: 'brendaGarcia',
      desc: '',
      args: [],
    );
  }

  /// `All Calls`
  String get allCalls {
    return Intl.message(
      'All Calls',
      name: 'allCalls',
      desc: '',
      args: [],
    );
  }

  /// `Missed Calls`
  String get missedCalls {
    return Intl.message(
      'Missed Calls',
      name: 'missedCalls',
      desc: '',
      args: [],
    );
  }

  /// `Call History`
  String get callHistory {
    return Intl.message(
      'Call History',
      name: 'callHistory',
      desc: '',
      args: [],
    );
  }

  /// `Add to favourite`
  String get addToFavourite {
    return Intl.message(
      'Add to favourite',
      name: 'addToFavourite',
      desc: '',
      args: [],
    );
  }

  /// `Delete contact`
  String get deleteContact {
    return Intl.message(
      'Delete contact',
      name: 'deleteContact',
      desc: '',
      args: [],
    );
  }

  /// `Outgoing call`
  String get outgoingCall {
    return Intl.message(
      'Outgoing call',
      name: 'outgoingCall',
      desc: '',
      args: [],
    );
  }

  /// `Incoming call`
  String get incomingCall {
    return Intl.message(
      'Incoming call',
      name: 'incomingCall',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Favourite`
  String get favourite {
    return Intl.message(
      'Favourite',
      name: 'favourite',
      desc: '',
      args: [],
    );
  }

  /// `Mute`
  String get mute {
    return Intl.message(
      'Mute',
      name: 'mute',
      desc: '',
      args: [],
    );
  }

  /// `Speaker`
  String get speaker {
    return Intl.message(
      'Speaker',
      name: 'speaker',
      desc: '',
      args: [],
    );
  }

  /// `Add Call`
  String get addCall {
    return Intl.message(
      'Add Call',
      name: 'addCall',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message(
      'Transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `Conference call`
  String get conferenceCall {
    return Intl.message(
      'Conference call',
      name: 'conferenceCall',
      desc: '',
      args: [],
    );
  }

  /// `Hold`
  String get hold {
    return Intl.message(
      'Hold',
      name: 'hold',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enterprise`
  String get enterprise {
    return Intl.message(
      'Enterprise',
      name: 'enterprise',
      desc: '',
      args: [],
    );
  }

  /// `SIP Username`
  String get userName {
    return Intl.message(
      'SIP Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Registrar Server`
  String get registrarServer {
    return Intl.message(
      'Registrar Server',
      name: 'registrarServer',
      desc: '',
      args: [],
    );
  }

  /// `WebRTC Socket URI`
  String get webRTCSocketURI {
    return Intl.message(
      'WebRTC Socket URI',
      name: 'webRTCSocketURI',
      desc: '',
      args: [],
    );
  }

  /// `Display Name`
  String get displayName {
    return Intl.message(
      'Display Name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get verifyOtp {
    return Intl.message(
      'Verify OTP',
      name: 'verifyOtp',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Email ID`
  String get emailID {
    return Intl.message(
      'Email ID',
      name: 'emailID',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get mobileNumber {
    return Intl.message(
      'Mobile number',
      name: 'mobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Remembered password?`
  String get rememberPassword {
    return Intl.message(
      'Remembered password?',
      name: 'rememberPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Create Password`
  String get createPassword {
    return Intl.message(
      'Create Password',
      name: 'createPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get enterPassword {
    return Intl.message(
      'Enter Password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter Provisioning URL or FQDN`
  String get emailProvisioning {
    return Intl.message(
      'Enter Provisioning URL or FQDN',
      name: 'emailProvisioning',
      desc: '',
      args: [],
    );
  }

  /// `Reset password`
  String get resetPassword {
    return Intl.message(
      'Reset password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email to reset`
  String get resetPasswordDescription {
    return Intl.message(
      'Enter your email to reset',
      name: 'resetPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Search Number`
  String get searchNumber {
    return Intl.message(
      'Search Number',
      name: 'searchNumber',
      desc: '',
      args: [],
    );
  }

  /// `Keypad`
  String get keypad {
    return Intl.message(
      'Keypad',
      name: 'keypad',
      desc: '',
      args: [],
    );
  }

  /// `conference`
  String get conference {
    return Intl.message(
      'Conference',
      name: 'conference',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Messaging`
  String get messaging {
    return Intl.message(
      'Messaging',
      name: 'messaging',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `or Login Using`
  String get orLoginUsing {
    return Intl.message(
      'or Login Using',
      name: 'orLoginUsing',
      desc: '',
      args: [],
    );
  }

  /// `Auto Provisioning`
  String get autoProvisioning {
    return Intl.message(
      'Auto Provisioning',
      name: 'autoProvisioning',
      desc: '',
      args: [],
    );
  }

  /// `Create group`
  String get createGroup {
    return Intl.message(
      'Create group',
      name: 'createGroup',
      desc: '',
      args: [],
    );
  }

  /// `Add Caption..`
  String get addCaption {
    return Intl.message(
      'Add Caption..',
      name: 'addCaption',
      desc: '',
      args: [],
    );
  }

  /// `New Chat`
  String get newChat {
    return Intl.message(
      'New Chat',
      name: 'newChat',
      desc: '',
      args: [],
    );
  }

  /// `Type your message...`
  String get typeYourMessage {
    return Intl.message(
      'Type your message...',
      name: 'typeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Forward to...`
  String get forwardTo {
    return Intl.message(
      'Forward to...',
      name: 'forwardTo',
      desc: '',
      args: [],
    );
  }

  /// `Add member`
  String get addMember {
    return Intl.message(
      'Add member',
      name: 'addMember',
      desc: '',
      args: [],
    );
  }

  /// `Remove from group`
  String get removeFromGroup {
    return Intl.message(
      'Remove from group',
      name: 'removeFromGroup',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Make group admin`
  String get makeGroupAdmin {
    return Intl.message(
      'Make group admin',
      name: 'makeGroupAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `Group info`
  String get groupInfo {
    return Intl.message(
      'Group info',
      name: 'groupInfo',
      desc: '',
      args: [],
    );
  }

  String get members {
    return Intl.message(
      'Members',
      name: 'members',
      desc: '',
      args: [],
    );
  }

  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

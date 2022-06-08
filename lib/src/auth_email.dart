import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthEmail {
  /// The name of the application. Must be the same as the appName on your server.
  final String appName;

  /// The URL point to the server side.
  final String server;

  /// An unencrypted server key.
  final String serverKey;

  /// Allow print debug log.
  final bool isDebug;

  /// Internal use only.
  String _finalOTP = '';
  String _finalEmail = '';

  /// Create a new AuthEmail instance.
  ///
  /// `appName`: the name of the application. Must be the same as the appName on your server.
  ///
  /// `server`: the URL point to the server side.
  ///
  /// `serverKey`: an unencrypted server key.
  AuthEmail({
    required this.appName,
    required this.server,
    required this.serverKey,
    this.isDebug = false,
  });

  /// Send an OTP tp the email.
  ///
  /// `body`: default is `Use this OTP to verify your email for the <b>{appName}</b>,
  ///  please do not share to anyone: {otp}`. this value only works when you set
  /// `modifiedBody` on your server for this `appName` to `true`.
  ///
  /// `otpLength`: Length of the OTP, this value only works when you set `modifiedOtpLength`
  /// on your server for this `appName` to `true`.
  Future<bool> sendOTP({
    required email,
    String body = '',
    int otpLength = 6,
  }) async {
    if (!isValidEmail(email)) return false;

    _finalEmail = email;
    final url = Uri.parse(
        '$server?appName=$appName&toMail=$email&serverKey=$serverKey&body=$body&otpLength=$otpLength');
    _printDebug('URL: $url');

    http.Response response = await http.get(url);
    final result = jsonDecode(response.body);
    _printDebug('HTTP RESPONSE: $result');

    if (result['status'] == 'ok') {
      _finalOTP = result['message'];
      return true;
    } else {
      _finalEmail = '';
      _finalOTP = '';
      return false;
    }
  }

  /// Verify the OTP that inputed by the user.
  ///
  /// `email`: The email address of the user.
  ///
  /// `otp`: The OTP to verify.
  bool verifyOTP({required String email, required String otp}) {
    if (_finalEmail == '' || _finalOTP == '') {
      return false;
    }
    if (email.trim() == _finalEmail && otp.trim() == _finalOTP) {
      return true;
    }
    return false;
  }

  /// This function will check if the provided email ID is valid or not
  static bool isValidEmail(String email) {
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  // ignore: avoid_print
  void _printDebug(Object? object) =>
      isDebug ? print('[Auth Email]: $object') : null;
}

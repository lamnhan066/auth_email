import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
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
  String _hashed = '';
  String _salt = '';

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
  /// [subject] is the email subject, default value is `Verify Email`, this value
  /// can be changed only when `modifiedSubject` for this `appName` on your server
  /// is set to `true`.
  ///
  /// [body] default is `Use this OTP to verify your email for the <b>{appName}</b>,
  ///  please do not share to anyone: {otp}`. this value can be changed only when you set
  /// `modifiedBody` on your server for this `appName` to `true`.
  ///
  /// [otpLength] is length of the OTP, this value only works when you set `modifiedOtpLength`
  /// on your server for this `appName` to `true`.
  Future<bool> sendOTP({
    required String email,
    String subject = '',
    String body = '',
    int otpLength = 6,
  }) async {
    if (!isValidEmail(email)) return false;

    final Map<String, String> uriBody = {
      'appName': appName,
      'toMail': email,
      'serverKey': serverKey,
      'subject': subject,
      'body': body,
      'otpLength': otpLength.toString(),
    };
    String uriBodyParams = '';
    uriBody.forEach((key, value) => uriBodyParams += '$key=$value&');
    final url = Uri.parse('$server?$uriBodyParams');
    _printDebug('URL: $url');

    http.Response response = await http.get(url);

    if (response.statusCode != 200) {
      _printDebug('HTTP RESPONSE CODE = ${response.statusCode} != 200');

      _hashed = '';
      _salt = '';
      return false;
    }

    final result = jsonDecode(response.body);
    _printDebug('HTTP RESPONSE: $result');

    if (result['status'] == 'ok') {
      _hashed = result['hashed'];
      _salt = result['salt'];
      return true;
    } else {
      _hashed = '';
      _salt = '';
      return false;
    }
  }

  /// Verify the OTP that inputed by the user.
  ///
  /// `email`: The email address of the user.
  ///
  /// `otp`: The OTP to verify.
  bool verifyOTP({required String email, required String otp}) {
    final encoded = utf8.encode('$email:$otp:$_salt');
    final hashed = sha256.convert(encoded).toString();

    if (hashed == _hashed) {
      return true;
    }

    return false;
  }

  /// This function will check if the provided email ID is valid or not.
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

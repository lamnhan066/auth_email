import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthEmail {
  final String appName;
  final String server;
  final String serverKey;
  final bool isDebug;

  String _finalOTP = '';
  String _finalEmail = '';

  AuthEmail({
    required this.appName,
    required this.server,
    required this.serverKey,
    this.isDebug = false,
  });

  /// [body] default is `Use this OTP to verify your email for the <b>{appName}</b>, please do not share to anyone: {otp}`
  Future<bool> sendOTP({
    required email,
    String body = '',
    int otpLength = 6,
  }) async {
    if (!isValidEmail(email)) return false;

    _finalEmail = email;
    final url = Uri.parse(
        '$server?appName=$appName&toMail=$email&serverKey=$serverKey&body=$body&otpLength=$otpLength');
    _printDebug(url);
    http.Response response = await http.get(url);

    final result = jsonDecode(response.body);
    _printDebug(result);
    if (result['status'] == 'ok') {
      _finalOTP = result['message'];
      return true;
    } else {
      _finalEmail = '';
      _finalOTP = '';
      return false;
    }
  }

  bool verifyOTP({required String email, required String otp}) {
    if (_finalEmail == '' || _finalOTP == '') {
      return false;
    }
    if (email.trim() == _finalEmail && otp.trim() == _finalOTP) {
      return true;
    }
    return false;
  }

  // ignore: avoid_print
  void _printDebug(Object? object) => isDebug ? print(object) : null;

  /// This function will check if the provided email ID is valid or not
  static bool isValidEmail(String email) {
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }
}

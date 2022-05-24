import 'dart:convert';
import 'dart:io';

import 'package:auth_email/auth_email.dart';

final authEmail = AuthEmail(
  appName: 'Auth Email Test',
  server: '<Your Server>',
  serverKey: 'authemailtestkey',
  isDebug: true,
);

void main() async {
  const desMail = 'exampleclient@gmail.com';

  final result = await authEmail.sendOTP(email: desMail);

  if (result) {
    print('Please input your OTP:');
    var line = stdin.readLineSync(encoding: utf8);
    if (line == null) {
      print('Can\'t read your OTP');
      return;
    }

    final isVerified = authEmail.verifyOTP(email: desMail, otp: line);
    if (isVerified) {
      print('OK');
    } else {
      print('ERROR');
    }
  }
}

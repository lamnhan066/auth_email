import 'package:auth_email/auth_email.dart';
import 'package:flutter/material.dart';

final authEmail = AuthEmail(
  appName: 'Auth Email Test',
  server: 'https://pub.vursin.com/auth-email',
  serverKey: 'authemailtestkey',
);

void main() async {
  runApp(const MaterialApp(home: AuthEmailApp()));
}

class AuthEmailApp extends StatefulWidget {
  const AuthEmailApp({Key? key}) : super(key: key);

  @override
  State<AuthEmailApp> createState() => _AuthEmailAppState();
}

class _AuthEmailAppState extends State<AuthEmailApp> {
  final destinationMail = 'lyoclone@gmail.com';

  String buttonName = 'Send OTP';

  bool isSent = false;
  String textField = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Email'),
      ),
      body: Column(
        children: [
          if (isSent)
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  buttonName = 'Sending OTP...';
                });

                final result = await authEmail.sendOTP(email: destinationMail);

                if (!result) {
                  setState(() {
                    buttonName = 'Send OTP failed!';
                  });
                }
                setState(() {
                  isSent = result;
                });
              },
              child: Text(buttonName),
            )
          else ...[
            TextField(
              onChanged: (value) {
                textField = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final result =
                    authEmail.verifyOTP(email: destinationMail, otp: textField);

                setState(() {
                  isSent = result;
                });
              },
              child: const Text('Verify OTP'),
            )
          ]
        ],
      ),
    );
  }
}

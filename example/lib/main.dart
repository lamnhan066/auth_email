import 'package:auth_email/auth_email.dart';
import 'package:flutter/material.dart';

// This only use for testing purposes.
final authEmail = AuthEmail(
  appName: 'Auth Email Test',
  server: '<Your Server>',
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
  String sendOtpButton = 'Send OTP';
  String verifyOtpButton = 'Verify OTP';

  bool isSent = false;
  String desEmailTextField = '';
  String verifyTextField = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Email'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!isSent) ...[
            const Text('Input your client email:'),
            TextFormField(
              textAlign: TextAlign.center,
              initialValue: desEmailTextField,
              onChanged: (value) {
                desEmailTextField = value;
              },
              validator: (value) {
                if (!AuthEmail.isValidEmail(desEmailTextField)) {
                  return 'This email is not valid!';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  sendOtpButton = 'Sending OTP...';
                });

                final result =
                    await authEmail.sendOTP(email: desEmailTextField);

                if (!result) {
                  setState(() {
                    sendOtpButton = 'Send OTP failed!';
                  });
                }
                setState(() {
                  isSent = result;
                });
              },
              child: Text(sendOtpButton),
            )
          ] else ...[
            const Text('Input your OTP:'),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                verifyTextField = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final result = authEmail.verifyOTP(
                    email: desEmailTextField, otp: verifyTextField);

                if (result) {
                  setState(() {
                    verifyOtpButton = 'Verified OTP';
                  });
                } else {
                  setState(() {
                    verifyOtpButton = 'Verify OTP failed!';
                  });
                }
              },
              child: Text(verifyOtpButton),
            )
          ]
        ],
      ),
    );
  }
}

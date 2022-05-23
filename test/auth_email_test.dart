import 'package:auth_email/auth_email.dart';

final emailOtp = AuthEmail(
  appName: 'Flickr Saver',
  server: 'https://auth.softs.dev/email',
  serverKey: 'ohYwh',
);

void main() async {
  const desMail = 'destination@gmail.com';

  final result = await emailOtp.sendOTP(email: desMail);
  if (result) {
    final isVerified = emailOtp.verifyOTP(email: desMail, otp: 'someOTP');
    if (isVerified) {
      print('OK');
    } else {
      print('ERROR');
    }
  }
}

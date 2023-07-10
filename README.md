# Auth Email

This is an easy way to authenticate user email with OTP using PHP as a backend in your own server.

## Server Side

* Download php server from [v0.0.3](https://raw.githubusercontent.com/vnniz/auth_email/main/server/php/releases/v0.0.3.zip) and modify `config.php` in `src` directory with your own configurations. Example:
  
``` php
// This is a simple configs, you can modify more configs in `index.php`.
$HOST = 'example.com';
$USER_NAME = 'auth@example.com';
$PASSWORD = 'password';
$PORT = 587;
$SEND_FROM = $USER_NAME;

$DEFAULT_SUBJECT = 'Verify Email';
$DEFAULT_BODY = 'Please use this OTP to verify your email for the <b>{appName}</b>, do not share this code to anyone: <b>{otp}</b>';
$DEFAULT_OTP_LENGTH = 6;

// client key: authemailtestkey
$SERVER_SHA256_KEY = '6955c3a2dbfd121697623896b38f5eb759d2cd503476980e14b9beb0cc036c4d';

// Security of your applications.
$ALLOWED_APPS = [
    // Name of application. Must be the same as `appName` on client side.
    'Auth Email Test' => [
        // Allow this app using modified subject or not.
        'modifiedSubject' => false,
        // Allow this app using modified body or not.
        'modifiedBody' => false,
        // Allow this app using modified otp length or not.
        'modifiedOtpLength' => false,
    ],
];
```

* Upload only files in `src` directory to your server.

## Client Side

* Add `auth_email` to your project as dependency.
* Create a controller for `auth_email`:
  
``` dart
final authEmail = AuthEmail(
    // Name of application. Must be available in the `$ALLOWED_APPS` on server.
    appName: 'Auth Email Test',
    // URL of your server.
    server: 'https://example.com/auth/email',
    // You client key.
    serverKey: 'authemailtestkey',
    // Allow print debug log or not.
    isDebug: true,
);
```

You can also change email `subject`, `body` and `otpLength` by its parameters as you want to, but you have to change the permissions on your php server config to `true` first.

* Send OTP code to your client email:

``` dart
final bool result = await authEmail.sendOTP(email: 'exampleclient@gmail.com');
```

* Verify OTP code:

``` dart
final bool isVerified = authEmail.verifyOTP(email: 'exampleclient@gmail.com', otp: '<code>');
```

## Additional

You can check the email is valid or not before sending OTP code by using:

``` dart
final bool isValidEmail = AuthEmail.isValidEmail('exampleclient@gmail.com');
```

## Test Server

* This project include a test server, you can create your own test app with this test sever by using this configuration:
  
  ```dart
  // This only use for testing purposes.
  final authEmail = AuthEmail(
    appName: 'Auth Email Example', // <- For testing, only this app name is allowed
    server: 'https://pub.lamnhan.dev/auth-email/api',
    serverKey: 'ohYwh',
  );
  ```

* You can also test this plugin on [web](https://pub.lamnhan.dev/auth-email).
* Please use this config for testing only.

## Contributions

* Feel free to file an issue if you find any bugs or something is missing, PR is also welcome.

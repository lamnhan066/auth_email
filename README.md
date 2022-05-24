# Auth Email

This is an easy way to authenticate user email with OTP using PHP as a backend in your own server.

## Server Side

* Download `php_server` from [here](https://github.com/vursin/auth_email/blob/main/php_server/releases/v0.0.1.zip?raw=true) and modify `config.php` with your own configurations. Example:
  
``` php
// This is a simple configs, you can modify more configs in `index.php`.
$HOST = 'example.com';
$USER_NAME = 'auth@example.com';
$PASSWORD = 'password';
$PORT = 587;
$SEND_FROM = $USER_NAME;

$DEFAULT_BODY = 'Please use this OTP to verify your email for the <b>{appName}</b>, do not share this code to anyone: <b>{otp}</b>';
$DEFAULT_OTP_LENGTH = 6;

// client key: authemailtestkey
$SERVER_SHA256_KEY = '6955c3a2dbfd121697623896b38f5eb759d2cd503476980e14b9beb0cc036c4d';

// Security of your applications.
$ALLOWED_APPS = [
    // Name of application. Must be the same as `appName` on client side.
    'Auth Email Test' => [
        // Allow this app using modified body or not.
        'modifiedBody' => false,
        // Allow this app using modified otp length or not.
        'modifiedOtpLength' => false,
    ],
];
```

* Upload it to your server.

## Client Side

* Add `auth_email` to your project as dependencies.
* Create a controller for `auth_email`:
  
``` dart
final authEmail = AuthEmail(
    // Name of application. Must be the same as `authEmail` on server side.
    appName: 'Auth Email Test',
    // URL of your server.
    server: 'https://example.com/auth-email',
    // You client key.
    serverKey: 'authemailtestkey',
    // Allow print debug log or not.
    isDebug: true,
);
```

* Send OTP code to your client email:

``` dart
final bool result = await authEmail.sendOTP(email: 'exampleclient@gmail.com');
```

* Verify OTP code:

``` dart
final bool isVerified = authEmail.verifyOTP(email: 'exampleclient@gmail.com', otp: '<code>');
```

## Addition

You can check the email is valid or not before sending OTP code by using:

```dart
final bool isValidEmail = AuthEmail.isValidEmail('exampleclient@gmail.com');
```

## Test Server

* This project include a test server, you can try it on web by accessing [here](<https://pub.vursin.com/auth-email/>)
* You can also try creating your own test app with this test sever by using this configuration:
  
``` dart
final authEmail = AuthEmail(
  appName: 'Auth Email Test',
  server: 'https://pub.vursin.com/auth-email/api',
  serverKey: 'authemailtestkey',
  isDebug: true,
);
```

* Please only use this config to test the plugin.

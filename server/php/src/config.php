<?php

// Version: 0.0.5

// Set the SMTP server to send through
$HOST = '';
// SMTP username
$USER_NAME = '';
// SMTP password
$PASSWORD = '';
// TCP port to connect to
$PORT = 587;
// Send from
$SEND_FROM = $USER_NAME;

// Default subject of Email
$DEFAULT_SUBJECT = 'Verify Email';
// Default body of Email
$DEFAULT_BODY = 'Please use this OTP to verify your email for the <b>{appName}</b>, do not share this code to anyone: <b>{otp}</b>';
// Default length of OTP
$DEFAULT_OTP_LENGTH = 6;

// Client key in SHA256 encryption
$SERVER_SHA256_KEY = '';

// Security of your applications.
$ALLOWED_APPS = [
    // 'App Name' => [
    //	   'modifiedSubject' => false,
    //     'modifiedBody' => false,
    //     'modifiedOtpLength' => false,
    // ],
];

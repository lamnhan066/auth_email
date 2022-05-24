<?php

// VERSION: 0.0.1

$HOST = '';
$USER_NAME = '';
$PASSWORD = '';
$PORT = 587;
$SEND_FROM = $USER_NAME;

$DEFAULT_BODY = 'Please use this OTP to verify your email for the <b>{appName}</b>, do not share this code to anyone: <b>{otp}</b>';
$DEFAULT_OTP_LENGTH = 6;

$SERVER_SHA256_KEY = '';

$ALLOWED_APPS = [
    // 'App Name' => [
    //     'modifiedBody' => false,
    //     'modifiedOtpLength' => false,
    // ],
];

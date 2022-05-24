<?php

require 'config.php';

if (!isset($_GET['appName']) || $_GET['appName'] === '') {
    exit(json_encode(['status' => 'fail', 'message' => 'missing-params']));
}

if (!isset($_GET['toMail']) || $_GET['toMail'] === '') {
    exit(json_encode(['status' => 'fail', 'message' => 'missing-params']));
}

// Body can be an empty string
if (!isset($_GET['body'])) {
    exit(json_encode(['status' => 'fail', 'message' => 'missing-params']));
}

if (!isset($_GET['serverKey']) || $_GET['serverKey'] === '') {
    exit(json_encode(['status' => 'fail', 'message' => 'missing-params']));
}

if (!isset($_GET['otpLength'])) {
    exit(json_encode(['status' => 'fail', 'message' => 'missing-params']));
}

// Get server key and compare
$serverKey = filter_var($_GET['serverKey']);
if (!$serverKey) {
    exit(json_encode(['status' => 'fail', 'message' => 'invalid-server-key']));
}

// Compare server key
if (hash('sha256', $serverKey) !== $SERVER_SHA256_KEY) {
    exit(json_encode(['status' => 'fail', 'message' => 'server-key-mismatch']));
}

// Get variables
$appName = filter_var($_GET['appName']);
if (!$appName || !array_key_exists($appName, $ALLOWED_APPS)) {
    exit(json_encode(['status' => 'fail', 'message' => 'invalid-app-name']));
}

// to mail value
$toMail = filter_var($_GET['toMail'], FILTER_VALIDATE_EMAIL);
if (!$toMail) {
    exit(json_encode(['status' => 'fail', 'message' => 'invalid-email']));
}

// This is the default OTP text
$body = $DEFAULT_BODY;
if ($ALLOWED_APPS[$appName]['modifiedBody']) {
    $_body = filter_var($_GET['body']);
    if ($_body && str_contains($_body, '{appName}') && str_contains($_body, '{email}') && str_contains($_body, '{otp}')) {
        $body = $_body;
    }
}

$otpLength = $DEFAULT_OTP_LENGTH;
if ($ALLOWED_APPS[$appName]['modifiedOtpLength']) {
    $_otpLength = filter_var($_GET['otpLength']);
    if ($_otpLength && $_otpLength !== '') {
        $otpLength = $_otpLength;
    }
}

require __DIR__.'/PHPMailer/src/Exception.php';
require __DIR__.'/PHPMailer/src/PHPMailer.php';
require __DIR__.'/PHPMailer/src/SMTP.php';

//Import PHPMailer classes into the global namespace
//These must be at the top of your script, not inside a function
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;

// Create an instance; passing `true` enables exceptions
// https://github.com/PHPMailer/PHPMailer
$mail = new PHPMailer(true);
$otp = generateOtp($otpLength);

try {
    //Server settings
    $mail->SMTPDebug = SMTP::DEBUG_OFF; //Enable verbose debug output
    $mail->isSMTP(); //Send using SMTP
    $mail->Host = $HOST; //Set the SMTP server to send through
    $mail->SMTPAuth = true; //Enable SMTP authentication
    $mail->Username = $USER_NAME; //SMTP username
    $mail->Password = $PASSWORD; //SMTP PASSWORD
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS; //Enable implicit TLS encryption
    $mail->Port = $PORT; //TCP port to connect to; use 587 if you have set `SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS` else `PHPMailer::ENCRYPTION_SMTPS`

    //Recipients
    $mail->setFrom($SEND_FROM, $appName);
    $mail->addAddress($toMail);     //Add a recipient

    //Content
    $mail->isHTML(true);                                  //Set email format to HTML
    $mail->Subject = 'Verify Email';
    $mail->Body = strtr($body, [
        '{appName}' => $appName,
        '{otp}' => $otp,
    ]);

    $mail->send();
    exit(json_encode(['status' => 'ok', 'message' => $otp]));
} catch (Exception $e) {
    $log = "<-- Package Auth_Email Error --->\n$e\n<-- Package Auth_Email Error --->";
    file_put_contents('php://stderr', var_export($log, true));
    exit(json_encode(['status' => 'fail', 'message' => 'unexpected']));
}

function generateOtp($length = 6): string
{
    return rand((int) ('1'.str_repeat('0', $length - 1)), (int) (str_repeat('9', $length)));
}

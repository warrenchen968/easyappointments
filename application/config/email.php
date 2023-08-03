e<?php defined('BASEPATH') or exit('No direct script access allowed');

// Add custom values by settings them to the $config array.
// Example: $config['smtp_host'] = 'smtp.gmail.com';
// @link https://codeigniter.com/user_guide/libraries/email.html


// Assuming you have the following constants defined in your Config class or file:
// const SMTP_DEBUG = '0'; // or '1'
// const SMTP_AUTH = TRUE; // or FALSE for anonymous relay.
// const SMTP_HOST = '';
// const SMTP_USER = '';
// const SMTP_PASS = '';
// const SMTP_CRYPTO = 'ssl'; // or 'tls'
// const SMTP_PORT = 25;

$config['useragent'] = 'Easy!Appointments';
$config['protocol'] = 'smtp'; // or 'smtp'
$config['mailtype'] = 'html'; // or 'text'
$config['smtp_debug'] = '0'; // or '1'
$config['smtp_auth'] = TRUE; //or FALSE for anonymous relay.
$config['smtp_host'] = Config::SMTP_HOST;
$config['smtp_user'] = Config::SMTP_USER;
$config['smtp_pass'] = Config::SMTP_PASS;
$config['smtp_crypto'] = Config::SMTP_CRYPTO;
$config['smtp_port'] = Config::SMTP_PORT;

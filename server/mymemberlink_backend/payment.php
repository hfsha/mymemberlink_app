<?php
// Enable error reporting for debugging.
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Retrieve parameters from the GET request.
$email = $_GET['email']; // User's email
$phone = $_GET['phone']; // User's phone
$fullname = $_GET['fullname']; // User's full name
$membershipid = $_GET['membershipid']; // Membership ID
$userid = $_GET['usersid']; // User ID
$amount = $_GET['amount_paid']; // Payment amount

// Billplz API credentials and host details.
$api_key = '893b212b-98e0-4344-8df6-61f898719044';
$collection_id = 'cjy3jdpl';
$host = 'https://www.billplz-sandbox.com/api/v3/bills';

// Prepare data for Billplz API request.
$data = array(
    'collection_id' => $collection_id,
    'email' => $email,
    'phone' => $phone,
    'mobile' => $phone,
    'name' => $fullname,
    'amount' => ($amount * 100),
    'description' => 'Payment for membership by ' . $fullname,
    'callback_url' => "https://humancc.site/shahidatulhidayah/mymemberlink_backend/return_url",
    'redirect_url' => "https://humancc.site/shahidatulhidayah/mymemberlink_backend/payment_update.php?email=$email&phone=$phone&fullname=$fullname&membershipid=$membershipid&usersid=$userid&amount_paid=$amount"
);

// Initialize cURL session to send a request to Billplz.
$process = curl_init($host);
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data));

// Execute cURL request and fetch response.
$return = curl_exec($process);

// Close the cURL session.
curl_close($process);

// Decode the response from JSON to an associative array.
$bill = json_decode($return, true);

// Redirect the user to the payment URL.
if (isset($bill['url'])) {
    header("Location: {$bill['url']}");
} else {
    // If the response does not contain a URL, output an error message.
    $errorMessage = $bill['error']['message'] ?? 'Unknown error';
    if (is_array($errorMessage)) {
        // If the error message is an array, convert it to a string.
        $errorMessage = json_encode($errorMessage);
    }
    echo "Error creating payment: " . htmlspecialchars($errorMessage);
}
?>

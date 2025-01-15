<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Include database connection
include_once("dbconnect.php");

// Accept both GET and POST for userid
$userid = isset($_POST['userid']) ? $_POST['userid'] : (isset($_GET['userid']) ? $_GET['userid'] : null);

// Debugging: Log POST and GET data
error_log("POST Data: " . json_encode($_POST));
error_log("GET Data: " . json_encode($_GET));
error_log("Resolved userid: " . $userid);

// If no userid provided, return an error response
if (!$userid) {
    error_log("Error: No userid provided.");
    $response = array('status' => 'failed', 'data' => null, 'message' => 'No userid provided');
    sendJsonResponse($response);
    exit();
}

// Prepare and execute SQL query to retrieve user details
$sqlloaduser = "SELECT * FROM `user` WHERE `userid` = ?";
$stmt = $conn->prepare($sqlloaduser);

if ($stmt === false) {
    error_log("Error: SQL statement preparation failed. " . $conn->error);
    $response = array('status' => 'failed', 'data' => null, 'message' => 'Internal Server Error');
    sendJsonResponse($response);
    exit();
}

$stmt->bind_param("s", $userid);
$stmt->execute();
$result = $stmt->get_result();

// Check if user exists
if ($result->num_rows > 0) {
    $userdata = $result->fetch_assoc();
    $user = array(
        'userid' => $userdata['userid'],
        'fullname' => $userdata['fullname'],
        'phone' => $userdata['phone'],
        'email' => $userdata['email'],
        'member_type' => $userdata['member_type'],
        'registerdate' => $userdata['registerdate']
    );
    $response = array('status' => 'success', 'data' => $user);
    sendJsonResponse($response);
} else {
    error_log("Error: User with userid $userid not found.");
    $response = array('status' => 'failed', 'data' => null, 'message' => 'User not found');
    sendJsonResponse($response);
}

// Function to send JSON response
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

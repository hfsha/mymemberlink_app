<?php
// Debugging: Log the request method
error_log('Request Method: ' . $_SERVER['REQUEST_METHOD']);

// Handle OPTIONS request for CORS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header('Access-Control-Allow-Methods: POST, GET, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    http_response_code(200);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    $response = array('status' => 'failed', 'data' => 'Invalid request method');
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (!$conn) {
    $response = array('status' => 'failed', 'message' => 'Database connection failed');
    sendJsonResponse($response);
    die();
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    echo json_encode($sentArray);
    exit();
}

if (!isset($_POST['email']) || !isset($_POST['password'])) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Missing credentials'));
}

$email = mysqli_real_escape_string($conn, $_POST['email']);
$password = sha1($_POST['password']); // Use SHA1 as per your current code.

// Query to check login credentials
$sqllogin = "SELECT * FROM `user` WHERE `email` = ? AND `password` = ?";
$stmt = $conn->prepare($sqllogin);
$stmt->bind_param("ss", $email, $password);
$stmt->execute();
$result = $stmt->get_result();

if (!$result) {
    sendJsonResponse(array('status' => 'failed', 'message' => mysqli_error($conn)));
}

if ($result->num_rows > 0) {
    $userdata = $result->fetch_assoc();
    sendJsonResponse(array(
        'status' => 'success',
        'data' => array(
            'userid' => $userdata['userid'],
            'fullname' => $userdata['fullname'],
            'phone' => $userdata['phone'],
            'email' => $userdata['email'],
            'password' => $userdata['password'],
            'membership_id' => $userdata['membership_id'],
            'member_type' => $userdata['member_type'],
            'registerdate' => $userdata['registerdate'],
        )
    ));
} else {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Invalid credentials'));
}

$conn->close();
?>

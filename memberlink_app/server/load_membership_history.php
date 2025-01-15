<?php
// Include database connection
include_once("dbconnect.php");

// Enable error reporting for debugging
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Function to send JSON responses
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
    echo json_encode($sentArray);
    exit();
}

// Check if database connection is successful
if (!$conn) {
    $response = array('status' => 'failed', 'message' => 'Database connection failed');
    sendJsonResponse($response);
}

// Validate and retrieve 'userid' from query parameters
$userid = isset($_GET['userid']) ? trim($_GET['userid']) : null;
if (empty($userid)) {
    $response = array('status' => 'failed', 'message' => 'User ID is missing');
    sendJsonResponse($response);
}

// Debugging: Log the incoming request
error_log("Request received with userid: $userid");

// SQL query to retrieve membership history
$sqlLoadHistory = "SELECT * FROM tbl_payments WHERE userid = ? ORDER BY purchase_date DESC";

// Prepare the SQL statement to prevent SQL injection
$stmt = $conn->prepare($sqlLoadHistory);
if (!$stmt) {
    $response = array('status' => 'failed', 'message' => 'Database query preparation failed', 'error' => $conn->error);
    sendJsonResponse($response);
}

// Bind parameters and execute the statement
$stmt->bind_param("s", $userid);
$stmt->execute();

// Retrieve results
$result = $stmt->get_result();
$history = array();

if ($result) {
    if ($result->num_rows > 0) {
        $history["history"] = array();
        while ($row = $result->fetch_assoc()) {
            $record = array();
            $record['payment_id'] = $row['payment_id'];
            $record['membership_id'] = $row['membership_id'];
            $record['userid'] = $row['userid'];
            $record['amount_paid'] = $row['amount_paid'];
            $record['payment_status'] = $row['payment_status'];
            $record['purchase_date'] = $row['purchase_date'];
            $record['payment_billplz_id'] = $row['payment_billplz_id'];
            array_push($history["history"], $record);
        }
        $response = array('status' => 'success', 'data' => $history);
    } else {
        $response = array('status' => 'failed', 'message' => 'No payment history found', 'data' => $history);
    }
} else {
    $response = array(
        'status' => 'failed',
        'message' => 'Database query failed',
        'error' => $stmt->error,
        'data' => $history
    );
}

// Close the statement and connection
$stmt->close();
$conn->close();

// Send the JSON response
sendJsonResponse($response);
?>

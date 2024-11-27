<?php
if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    $response = array('status' => 'failed', 'message' => 'Invalid request method');
    sendJsonResponse($response);
    die;
}

if (!isset($_POST['newsid']) || !is_numeric($_POST['newsid'])) {
    $response = array('status' => 'failed', 'message' => 'Invalid news ID');
    sendJsonResponse($response);
    die;
}

include_once('dbconnect.php');
$newsid = $_POST['newsid'];

// Prepare the delete query using a prepared statement to prevent SQL injection
$sql = "DELETE FROM `tbl_news` WHERE `news_id` = ?";
$stmt = $conn->prepare($sql);

if ($stmt === false) {
    $response = array('status' => 'failed', 'message' => 'Error preparing the query');
    sendJsonResponse($response);
    die;
}

$stmt->bind_param('i', $newsid);

if ($stmt->execute()) {
    if ($stmt->affected_rows > 0) {
        $response = array('status' => 'success', 'message' => 'News item deleted successfully');
    } else {
        $response = array('status' => 'failed', 'message' => 'No matching news item found');
    }
} else {
    $response = array('status' => 'failed', 'message' => 'Error executing the query');
}

$stmt->close();
sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$fullname = $_POST['fullname'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = sha1($_POST['password']);

// Check if the email already exists
$sqlcheck = "SELECT * FROM `user` WHERE `email` = '$email'";
$result = $conn->query($sqlcheck);

if ($result->num_rows > 0) {
	$response = array('status' => 'email_exists', 'data' => null);
    sendJsonResponse($response);
    die;
}

// If the email does not exist, proceed with the registration
$sqlinsert = "INSERT INTO `user`(`fullname`, `phone`, `email`, `password`) VALUES ('$fullname','$phone','$email','$password')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

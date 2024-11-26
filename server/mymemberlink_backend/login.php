<?php
if (!isset($_POST)) {
	$response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqllogin = "SELECT  `email`, `password` FROM `user` WHERE `email`= '$email' AND `password` = '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
	
	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
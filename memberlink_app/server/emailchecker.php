<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$email = $_POST['email'];

$sqlcheck = "SELECT `email` FROM `user` WHERE `email` = '$email'";
$result = $conn->query($sqlcheck);

if ($result->num_rows > 0) {  //more than 0 means success
    $response = array('status' => 'exist', 'data' => null); 
    sendJsonResponse($response); 
}else{  //not success
    $response = array('status' => 'available', 'data' => null); 
    sendJsonResponse($response); 
}


function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>
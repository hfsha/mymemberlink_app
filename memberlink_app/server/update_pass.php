<?php
if (!isset($_POST)) { 
    $response = array('status' => 'failed', 'data' => null); 
    sendJsonResponse($response); 
    die; 
}

include_once("dbconnect.php");
$email = $_POST['email'];
$new_password = sha1($_POST['password']); // Hash the new password

// Check if email exists in the database
$sqlemailcheck = "SELECT `email` FROM `user` WHERE `email` = '?'";
$result = $conn->query($sqlemailcheck);

if ($result->num_rows > 0) {
    // Email exists, update the password
    $sqlupdate = "UPDATE `user` SET `password` = '$password' WHERE `email` = '$email'";
    
    if ($conn->query($sqlupdate) === TRUE) {
        // Password updated successfully
        $response = array('status' => 'success', 'data' => null);
    } else {
        // Failed to update the password
        $response = array('status' => 'update_failed', 'data' => null);
    }
} else {
    // Email does not exist in the database
    $response = array('status' => 'no_email', 'data' => null);
}

sendJsonResponse($response); 

function sendJsonResponse($sentArray) 
{ 
    header('Content-Type: application/json'); 
    echo json_encode($sentArray); 
}

?>
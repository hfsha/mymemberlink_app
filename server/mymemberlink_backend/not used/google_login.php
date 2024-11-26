<?php
include 'db_connect.php';

$oauthId = $_POST['oauth_id'];
$fullName = $_POST['full_name'];
$email = $_POST['email'];

$checkUser = $conn->query("SELECT * FROM users WHERE oauth_id='$oauthId' AND provider='google'");
if ($checkUser->num_rows > 0) {
    echo json_encode(['status' => 'success', 'message' => 'Google login successful']);
} else {
    $sql = "INSERT INTO users (full_name, email, provider, oauth_id) VALUES ('$fullName', '$email', 'google', '$oauthId')";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(['status' => 'success', 'message' => 'User registered via Google login']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Google login failed']);
    }
}
?>

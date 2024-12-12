<?php
include 'db_connect.php';

$oauthId = $_POST['oauth_id'];
$fullName = $_POST['full_name'];
$email = $_POST['email'];

$checkUser = $conn->query("SELECT * FROM users WHERE oauth_id='$oauthId' AND provider='facebook'");
if ($checkUser->num_rows > 0) {
    echo json_encode(['status' => 'success', 'message' => 'Facebook login successful']);
} else {
    $sql = "INSERT INTO users (full_name, email, provider, oauth_id) VALUES ('$fullName', '$email', 'facebook', '$oauthId')";
    if ($conn->query($sql) === TRUE) {
        echo json_encode(['status' => 'success', 'message' => 'User registered via Facebook login']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Facebook login failed']);
    }
}
?>


<?php
$servername = "localhost";
$username   = "humancmt_hfsha_mymemberlink_admin";
$password   = ";1E45S(z?G2f";
$dbname     = "humancmt_hfsha_mymemberlink_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
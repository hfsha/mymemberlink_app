<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

include_once("dbconnect.php");

if (!isset($_GET['userid'])) {
    echo json_encode([
        "status" => "failed",
        "message" => "User ID is required"
    ]);
    exit();
}

$userid = $_GET['userid'];

$sql = "SELECT payment_id, membership_id, amount_paid, payment_status, purchase_date, payment_billplz_id 
        FROM tbl_payments 
        WHERE userid = ? 
        ORDER BY purchase_date DESC";

$stmt = $conn->prepare($sql);
$stmt->bind_param('i', $userid);

if ($stmt->execute()) {
    $result = $stmt->get_result();
    $payments = array();
    
    while ($row = $result->fetch_assoc()) {
        $payments[] = $row;
    }
    
    echo json_encode([
        "status" => "success",
        "data" => $payments
    ]);
} else {
    echo json_encode([
        "status" => "failed",
        "message" => "Failed to load payment history"
    ]);
}

$stmt->close();
$conn->close();
?> 
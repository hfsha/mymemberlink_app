<?php
if (!isset($_POST['product_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die;
}

include_once('dbconnect.php');
$product_id = $_POST['product_id'];

$sqldeleteproduct = "DELETE FROM `tbl_products` WHERE `product_id` = '$product_id'";

if ($conn->query($sqldeleteproduct) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => 'Failed to delete product');
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

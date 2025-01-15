<?php
include_once("dbconnect.php");

// Set the number of results per page
$results_per_page = 20;
$pageno = isset($_GET['pageno']) ? (int)$_GET['pageno'] : 1; // Default to page 1 if no parameter passed
$page_first_result = ($pageno - 1) * $results_per_page;

// Set connection charset to UTF-8
$conn->set_charset("utf8mb4");

try {
    // SQL query to fetch products with pagination
    $sqlloadproducts = "SELECT * FROM `tbl_products` ORDER BY `product_date` DESC LIMIT $page_first_result, $results_per_page";
    $result = $conn->query($sqlloadproducts);
    if (!$result) {
        throw new Exception("Error executing product query: " . $conn->error);
    }

    // Get total number of records
    $sqltotal = "SELECT COUNT(*) AS total FROM `tbl_products`";
    $totalresult = $conn->query($sqltotal);
    if (!$totalresult) {
        throw new Exception("Error executing count query: " . $conn->error);
    }

    $totalrow = $totalresult->fetch_assoc();
    $number_of_result = $totalrow['total'];
    $number_of_page = ceil($number_of_result / $results_per_page);

    // Prepare response
    if ($result->num_rows > 0) {
        $productsarray['products'] = array();
        while ($row = $result->fetch_assoc()) {
            $product = array(
                'product_id' => $row['product_id'],
                'product_name' => utf8_encode($row['product_name']),
                'product_desc' => utf8_encode($row['product_desc']),
                'product_price' => $row['product_price'],
                'product_quantity' => $row['product_quantity'],
                'product_filename' => utf8_encode($row['product_filename']),
                'product_date' => $row['product_date']
            );
            array_push($productsarray['products'], $product);
        }

        $response = array(
            'status' => 'success',
            'data' => $productsarray,
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        );
    } else {
        $response = array(
            'status' => 'failed',
            'message' => 'No products found',
            'data' => null,
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        );
    }

    sendJsonResponse($response);
} catch (Exception $e) {
    // Catch and handle exceptions
    $response = array(
        'status' => 'error',
        'message' => $e->getMessage(),
        'data' => null,
        'numofpage' => 0,
        'numberofresult' => 0
    );
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');

    // Encode to JSON and handle encoding errors
    $json = json_encode($sentArray, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    if (json_last_error() !== JSON_ERROR_NONE) {
        echo json_encode([
            'status' => 'error',
            'message' => 'JSON encoding error: ' . json_last_error_msg()
        ]);
        exit;
    }

    echo $json;
    exit;
}
?>

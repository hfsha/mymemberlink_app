<?php
include_once("dbconnect.php");

$results_per_page = 20;
if (isset($_GET['pageno'])) {
    $pageno = (int)$_GET['pageno'];
} else {
    $pageno = 1; // Default to page 1 if no page parameter is passed
}

// Calculate the starting record for the current page
$page_first_result = ($pageno - 1) * $results_per_page;

// SQL query to fetch the products, ordered by date
$sqlloadproducts = "SELECT * FROM `tbl_products` ORDER BY `product_date` DESC LIMIT $page_first_result, $results_per_page";

// Execute the query
$result = $conn->query($sqlloadproducts);

// Check if the query was successful
if ($result) {
    // Get the total number of records in the database
    $sqltotal = "SELECT COUNT(*) AS total FROM `tbl_products`";
    $totalresult = $conn->query($sqltotal);
    $totalrow = $totalresult->fetch_assoc();
    $number_of_result = $totalrow['total'];

    // Calculate the total number of pages
    $number_of_page = ceil($number_of_result / $results_per_page);

    // Prepare the array to return the products
    if ($result->num_rows > 0) {
        $productsarray['products'] = array();

        // Fetch each row and add to the products array
        while ($row = $result->fetch_assoc()) {
            $product = array();
            $product['product_id'] = $row['product_id'];
            $product['product_name'] = $row['product_name'];
            $product['product_desc'] = $row['product_desc'];
            $product['product_price'] = $row['product_price'];
            $product['product_quantity'] = $row['product_quantity'];
            $product['product_filename'] = $row['product_filename'];
            $product['product_date'] = $row['product_date'];
            array_push($productsarray['products'], $product);
        }

        // Send a successful response with the products data
        $response = array(
            'status' => 'success',
            'data' => $productsarray,
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        );
        sendJsonResponse($response);

    } else {
        // No products found, send a failed response
        $response = array(
            'status' => 'failed',
            'message' => 'No products found',
            'data' => null,
            'numofpage' => $number_of_page,
            'numberofresult' => $number_of_result
        );
        sendJsonResponse($response);
    }
} else {
    // If the query failed, send an error response
    $response = array(
        'status' => 'error',
        'message' => 'Database query failed: ' . $conn->error,
        'data' => null,
        'numofpage' => 0,
        'numberofresult' => 0
    );
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    // Set the header to JSON format
    header('Content-Type: application/json');

    // Send the JSON response
    echo json_encode($sentArray);
}

?>

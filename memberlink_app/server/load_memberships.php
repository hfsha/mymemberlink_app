<?php
if (!isset($_GET['pageno'])) {
    $pageno = 1;
} else {
    $pageno = (int)$_GET['pageno'];
}

include_once("dbconnect.php");

// For debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

$results_per_page = 10;
$page_first_result = ($pageno - 1) * $results_per_page;

try {
    // First, check if the table exists and has data
    $check_table = $conn->query("SHOW TABLES LIKE 'tbl_memberships'");
    if ($check_table->num_rows == 0) {
        throw new Exception("Table 'tbl_memberships' does not exist");
    }

    // Basic query
    $sqlloadmemberships = "SELECT * FROM tbl_memberships";
    
    // Add search if provided
    if (isset($_GET['search']) && !empty($_GET['search'])) {
        $search = $conn->real_escape_string($_GET['search']);
        $sqlloadmemberships .= " WHERE name LIKE '%$search%'";
    }
    
    // Get total count first
    $total_result = $conn->query($sqlloadmemberships);
    if (!$total_result) {
        throw new Exception("Query failed: " . $conn->error);
    }
    
    $total_records = $total_result->num_rows;
    $number_of_page = ceil($total_records / $results_per_page);
    
    // Add pagination to the main query
    $sqlloadmemberships .= " LIMIT $page_first_result, $results_per_page";
    $result = $conn->query($sqlloadmemberships);
    
    if ($result) {
        if ($result->num_rows > 0) {
            $memberships = array();
            while ($row = $result->fetch_assoc()) {
                // Convert membership_id to string since it's an integer in database
                $membership = array(
                    'membership_id' => strval($row['membership_id']), // Convert to string
                    'name' => $row['name'],
                    'description' => $row['description'],
                    'price' => floatval($row['price']), // Ensure it's a number
                    'benefits' => $row['benefits'],
                    'duration' => intval($row['duration']), // Ensure it's a number
                    'terms' => $row['terms']
                );
                array_push($memberships, $membership);
            }
            
            $response = array(
                'status' => 'success',
                'data' => $memberships,
                'numofpage' => strval($number_of_page),
                'numberofresult' => strval($total_records)
            );
        } else {
            $response = array(
                'status' => 'failed',
                'data' => [],  // Empty array instead of null
                'numofpage' => "0",
                'numberofresult' => "0",
                'message' => 'No memberships found'
            );
        }
    } else {
        throw new Exception("Failed to fetch memberships: " . $conn->error);
    }
} catch (Exception $e) {
    $response = array(
        'status' => 'failed',
        'data' => [],  // Empty array instead of null
        'numofpage' => "0",
        'numberofresult' => "0",
        'message' => 'Error: ' . $e->getMessage()
    );
}

// Debug: Print the response before sending
error_log(print_r($response, true));

sendJsonResponse($response);

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray, JSON_PRETTY_PRINT);
    exit;  // Ensure nothing else is output
}
?>
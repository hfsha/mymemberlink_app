<?php

include_once("dbconnect.php");

$results_per_page = 10;
if (isset($_GET['pageno'])) {
    $pageno = (int)$_GET['pageno'];
} else {
    $pageno = 1;
}

$page_first_result = ($pageno - 1) * $results_per_page;

// Check if a search query is provided
$searchQuery = "";
if (isset($_GET['search']) && !empty($_GET['search'])) {
    $searchQuery = $_GET['search'];
}

// Start constructing the SQL query
$sqlloadnews = "SELECT * FROM `tbl_news` WHERE 1";

// Add search filter if provided
if (!empty($searchQuery)) {
    $sqlloadnews .= " AND `news_title` LIKE '$searchQuery%'";
}

// Add date filtering if provided
if (isset($_GET['start_date']) && isset($_GET['end_date']) && !empty($_GET['start_date']) && !empty($_GET['end_date'])) {
    $start_date = $_GET['start_date'];
    $end_date = $_GET['end_date'];
    $sqlloadnews .= " AND `news_date` BETWEEN '$start_date' AND '$end_date'";
}

// Finalize query with sorting
$sqlloadnews .= " ORDER BY `news_date` DESC";

// Count total results before pagination
$result = $conn->query($sqlloadnews);
$number_of_result = $result->num_rows;

$number_of_page = ceil($number_of_result / $results_per_page);

// Apply pagination
$sqlloadnews .= " LIMIT $page_first_result, $results_per_page";
$result = $conn->query($sqlloadnews);

if ($result->num_rows > 0) {
    $newsarray['news'] = array();
    while ($row = $result->fetch_assoc()) {
        $news = array();
        $news['news_id'] = $row['news_id'];
        $news['news_title'] = $row['news_title'];
        $news['news_details'] = $row['news_details'];
        $news['news_date'] = $row['news_date'];
        array_push($newsarray['news'], $news);
    }
    $response = array('status' => 'success', 'data' => $newsarray, 'numofpage' => $number_of_page, 'numberofresult' => $number_of_result);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null, 'numofpage' => $number_of_page, 'numberofresult' => $number_of_result);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

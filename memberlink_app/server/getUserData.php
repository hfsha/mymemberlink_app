<?php
include_once("dbconnect.php");

try {
    // SQL query to fetch all users, filtering out rows with empty or null email
    $sql = "SELECT * FROM `user` WHERE `email` IS NOT NULL AND `email` != '' ORDER BY `registerdate` DESC";
    $result = $conn->query($sql);
    
    // Check if the query executed successfully
    if (!$result) {
        error_log("SQL Error: " . $conn->error); // Log SQL error
        throw new Exception("Error executing user query: " . $conn->error);
    }

    // Prepare the response based on the query result
    if ($result->num_rows > 0) {
        $usersarray['users'] = array(); // Array to hold user data

        while ($row = $result->fetch_assoc()) {
            // Add utf8_encode to handle special characters for all fields
            $user = array(
                'userid' => utf8_encode($row['userid']),
                'fullname' => utf8_encode($row['fullname']),
                'phone' => utf8_encode($row['phone']),
                'email' => utf8_encode($row['email']),
                'password' => utf8_encode($row['password']),
                'member_type' => utf8_encode($row['member_type']),
                'registerdate' => utf8_encode($row['registerdate'])
            );
            array_push($usersarray['users'], $user); // Append user to array
        }

        // Successful response
        $response = array(
            'status' => 'success',
            'data' => $usersarray,
            'numofpage' => 0,
            'numberofresult' => $result->num_rows
        );
    } else {
        // No users found response
        $response = array(
            'status' => 'failed',
            'message' => 'No users found',
            'data' => null,
            'numofpage' => 0,
            'numberofresult' => 0
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
        error_log("JSON Encoding Error: " . json_last_error_msg()); // Log error
        echo json_encode([
            'status' => 'error',
            'message' => 'JSON encoding error: ' . json_last_error_msg()
        ]);
        exit;
    }

    echo $json; // Send JSON response
    exit;
}
?>

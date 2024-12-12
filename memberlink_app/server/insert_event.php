<?php
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(0);

if (empty($_POST) || !isset($_POST['title'], $_POST['description'], $_POST['location'], $_POST['eventtype'], $_POST['start'], $_POST['end'], $_POST['image'])) {
    $response = array('status' => 'failed', 'data' => 'Missing required fields');
    sendJsonResponse($response);
    exit;
}

include_once("dbconnect.php");

$title = $_POST['title'];
$description = $_POST['description'];
$location = $_POST['location'];
$eventype = $_POST['eventtype'];
$startdate = $_POST['start'];
$enddate = $_POST['end'];
$image = $_POST['image'];

// Decode the base64 image
$decoded_image = base64_decode($image);
if ($decoded_image === false) {
    $response = array('status' => 'failed', 'data' => 'Invalid image encoding');
    sendJsonResponse($response);
    exit;
}

// Use absolute path for saving the image
$path = __DIR__ . "/assets/events/";
$filename = "event-" . randomfilename(10) . ".jpg";
$full_path = $path . $filename;

// Check if directory exists
if (!is_dir($path)) {
    $response = array('status' => 'failed', 'data' => 'Directory does not exist: ' . $path);
    sendJsonResponse($response);
    exit;
}

// Check if directory is writable
if (!is_writable($path)) {
    $response = array('status' => 'failed', 'data' => 'Directory not writable: ' . $path);
    sendJsonResponse($response);
    exit;
}

// Save the image
if (file_put_contents($full_path, $decoded_image)) {
    $stmt = $conn->prepare("INSERT INTO `tbl_events` (`event_title`, `event_description`, `event_startdate`, `event_enddate`, `event_type`, `event_location`, `event_filename`) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssss", $title, $description, $startdate, $enddate, $eventype, $location, $filename);

    if ($stmt->execute()) {
        $response = array('status' => 'success', 'data' => null);
    } else {
        $response = array('status' => 'failed', 'data' => 'Database insert failed');
    }

    $stmt->close();
} else {
    $error = error_get_last();
    $response = array('status' => 'failed', 'data' => 'Failed to save image: ' . $error['message']);
}

$conn->close();
sendJsonResponse($response);

function randomfilename($length) {
    $key = '';
    $keys = array_merge(range(0, 9), range('a', 'z'));
    for ($i = 0; $i < $length; $i++) {
        $key .= $keys[array_rand($keys)];
    }
    return $key;
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit;
}
?>

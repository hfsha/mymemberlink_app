<?php
include 'db.php';

$query = "SELECT * FROM users";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        echo "ID: " . $row['id'] . " | Name: " . $row['full_name'] . " | Phone: " . $row['phone'] . " | Email: " . $row['email'] . "<br>";
    }
} else {
    echo "No records found.";
}

$conn->close();
?>

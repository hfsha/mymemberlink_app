<?php
error_reporting(E_ALL); // Enable all error reporting for debugging.
ini_set('display_errors', 1);
include_once("dbconnect.php");

// Check database connection
if ($conn->connect_error) {
    error_log("Database Connection Failed: " . $conn->connect_error);
    exit("Error: Failed to connect to database.");
}

// Get parameters from URL
$fullname = $_GET['fullname'];
$email = $_GET['email'];
$phone = $_GET['phone'];
$membershipId = $_GET['membershipid'];
$userId = $_GET['usersid'];
$amount = $_GET['amount_paid'];

$data = array(
    'id' => $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'],
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$receiptId = $data['id'];
$paidStatus = $data['paid'] === "true" ? "Success" : "Failed";

// Assign status color based on payment status
$statusColor = ($paidStatus === "Success") ? "w3-text-green" : "w3-text-red";

// Verify x_signature
$signing = '';
foreach ($data as $key => $value) {
    $signing .= 'billplz' . $key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}

$secretKey = 'e3f838bf4c51b3433f257fda21d45ef719f1a831389dd823bd6eb4d8170922fe7213ac260963a9cd46b8ecbcafb17c10249dbee647d9098f6dfaa17f5f086302';
$signed = hash_hmac('sha256', $signing, $secretKey);

if ($signed !== $data['x_signature']) {
    error_log("Invalid Signature: Expected $signed, Got {$data['x_signature']}");
    exit("Error: Invalid Signature");
}

// Insert or Update the database based on payment status
if ($paidStatus === "Success") {
    // Log the incoming data
    error_log("Attempting to insert payment record with: userId=$userId, amount=$amount, status=$paidStatus, billplzId=$receiptId");
    
    // First, check if a record with this billplz_id already exists
    $checkQuery = "SELECT payment_id FROM tbl_payments WHERE payment_billplz_id = ?";
    $checkStmt = $conn->prepare($checkQuery);
    if (!$checkStmt) {
        error_log("Check Statement Preparation Failed: " . $conn->error);
        exit("Error: Failed to prepare check statement.");
    }
    
    $checkStmt->bind_param('s', $receiptId);
    $checkStmt->execute();
    $checkResult = $checkStmt->get_result();
    
    if ($checkResult->num_rows > 0) {
        error_log("Payment record already exists for billplz_id: $receiptId");
        $checkStmt->close();
    } else {
        $checkStmt->close();
        
        // Proceed with insertion - modified to match your table structure
        $query = "INSERT INTO tbl_payments (userid, membership_id, amount_paid, payment_status, payment_billplz_id) 
                 VALUES (?, ?, ?, ?, ?)";
        
        $stmt = $conn->prepare($query);
        if (!$stmt) {
            error_log("Insert Statement Preparation Failed: " . $conn->error);
            exit("Error: Failed to prepare insert statement.");
        }
        
        // Convert userid and membershipid to integer and amount to decimal
        $userIdInt = intval($userId);
        $membershipIdInt = intval($membershipId);
        $amountFloat = floatval($amount);
        
        // Bind parameters according to your table structure
        $stmt->bind_param('iidss',
            $userIdInt,        // userid as integer
            $membershipIdInt,  // membership_id as integer
            $amountFloat,      // amount_paid as decimal
            $paidStatus,       // payment_status as string
            $receiptId         // payment_billplz_id as string
        );
        
        if (!$stmt->execute()) {
            error_log("Error inserting payment record: " . $stmt->error);
            exit("Error: Failed to insert payment record. " . $stmt->error);
        } else {
            error_log("Payment record inserted successfully. Insert ID: " . $stmt->insert_id);
        }
        
        $stmt->close();
    }
}

// Display the receipt
echo "
<html>
<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
<link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
<body>
<center><h4>Receipt</h4></center>
<table class='w3-table w3-striped'>
<th>Item</th><th>Description</th>
<tr><td>Receipt</td><td>$receiptId</td></tr>
<tr><td>Name</td><td>$fullname</td></tr>
<tr><td>Email</td><td>$email</td></tr>
<tr><td>Phone</td><td>$phone</td></tr>
<tr><td>Membership ID</td><td>$membershipId</td></tr>
<tr><td>Paid Amount</td><td>RM $amount</td></tr>
<tr><td>Paid Status</td><td class='$statusColor'>$paidStatus</td></tr>
</table><br>
</body>
</html>";

$conn->close();
?>

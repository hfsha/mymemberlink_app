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
$statusColor = ($paidStatus === "Success") ? "success" : "failed";

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

// Always attempt to insert or update the payment record
error_log("Attempting to insert payment record with: userId=$userId, amount=$amount, status=$paidStatus, billplzId=$receiptId");

// Check if a record with this billplz_id already exists
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

    // Proceed with insertion
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
    
    // Bind parameters
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

// Display the receipt
echo "
<!DOCTYPE html>
<html lang=\"en\">
<head>
    <meta charset=\"UTF-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
    <link href=\"https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap\" rel=\"stylesheet\">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f7f7f7;
            margin: 0;
            padding: 0;
        }
        .receipt-container {
            max-width: 600px;
            margin: 50px auto;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }
        .receipt-header {
            text-align: center;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .receipt-header h4 {
            color: #333;
            margin: 0;
        }
        .receipt-table {
            width: 100%;
            border-collapse: collapse;
        }
        .receipt-table th, .receipt-table td {
            padding: 10px;
            text-align: left;
        }
        .receipt-table th {
            background: #4CAF50;
            color: white;
            font-weight: bold;
        }
        .receipt-table tr:nth-child(even) {
            background: #f2f2f2;
        }
        .status {
            font-weight: bold;
        }
        .status.success {
            color: #4CAF50;
        }
        .status.failed {
            color: #f44336;
        }
        .print-btn {
            display: block;
            width: 100px;
            margin: 20px auto;
            padding: 10px;
            background-color: #4CAF50;
            color: white;
            text-align: center;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        .print-btn:hover {
            background-color: #45a049;
        }
    </style>
    <script>
        function printReceipt() {
            window.print();
        }
    </script>
</head>
<body>
    <div class=\"receipt-container\">
        <div class=\"receipt-header\">
            <h4>Payment Receipt</h4>
        </div>
        <table class=\"receipt-table\">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Receipt ID</td>
                    <td>$receiptId</td>
                </tr>
                <tr>
                    <td>Name</td>
                    <td>$fullname</td>
                </tr>
                <tr>
                    <td>Email</td>
                    <td>$email</td>
                </tr>
                <tr>
                    <td>Phone</td>
                    <td>$phone</td>
                </tr>
                <tr>
                    <td>Membership ID</td>
                    <td>$membershipId</td>
                </tr>
                <tr>
                    <td>Paid Amount</td>
                    <td>RM $amount</td>
                </tr>
                <tr>
                    <td>Paid Status</td>
                    <td class=\"status $statusColor\">$paidStatus</td>
                </tr>
            </tbody>
        </table>
        <div class=\"print-btn\" onclick=\"printReceipt()\">Print</div>
    </div>
</body>
</html>";


$conn->close();
?>

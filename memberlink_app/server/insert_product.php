<?php
// Disable display of errors to avoid unexpected HTML output
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', __DIR__ . '/error.log'); // Log errors to a file

header('Content-Type: application/json'); // Ensure JSON response

try {
    // Check required fields
    if (empty($_POST) || 
        !isset($_POST['product_name'], $_POST['product_desc'], $_POST['product_quantity'], $_POST['product_price'], $_POST['image'])) {
        throw new Exception('Missing required fields');
    }

    include_once("dbconnect.php");

    // Get POST data
    $name = $_POST['product_name'];
    $description = $_POST['product_desc'];
    $quantity = $_POST['product_quantity'];
    $price = $_POST['product_price'];
    $image = $_POST['image'];

    // Decode and save the image
    $decoded_image = base64_decode($image);
    if ($decoded_image === false) {
        throw new Exception('Invalid image encoding');
    }

    $path = __DIR__ . "/assets/products/";
    $filename = "product-" . randomfilename(10) . ".jpg";
    if (!file_put_contents($path . $filename, $decoded_image)) {
        throw new Exception('Failed to save image');
    }

    // Insert into the database
    $product_date = date('Y-m-d H:i:s');
    $stmt = $conn->prepare("INSERT INTO `tbl_products` 
                            (`product_name`, `product_desc`, `product_quantity`, `product_price`, `product_filename`, `product_date`) 
                            VALUES (?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("ssisss", $name, $description, $quantity, $price, $filename, $product_date);

    if (!$stmt->execute()) {
        throw new Exception('Database insert failed: ' . $stmt->error);
    }

    // Respond with success
    $response = array('status' => 'success', 'data' => null);
    echo json_encode($response);
} catch (Exception $e) {
    // Respond with error
    $response = array('status' => 'failed', 'data' => $e->getMessage());
    echo json_encode($response);
}

// Function to generate random filenames
function randomfilename($length) {
    $key = '';
    $keys = array_merge(range(0, 9), range('a', 'z'));
    for ($i = 0; $i < $length; $i++) {
        $key .= $keys[array_rand($keys)];
    }
    return $key;
}
?>

<?php
$db = mysqli_connect('localhost', 'root', '', 'project_tpm');
if (!$db) {
    echo json_encode("Database connection failed");
    exit();
}

$password = $_POST['password'];
$username = $_POST['username'];

// Check if username already exists
$sql = "SELECT username FROM user WHERE username = '" . $username . "'";
$result = mysqli_query($db, $sql);
$count = mysqli_num_rows($result);

if ($count == 1) {
    echo json_encode("Error");
    exit();
}

// Handle image upload
$imagePath = null;
if (isset($_FILES['image']) && $_FILES['image']['error'] == UPLOAD_ERR_OK) {
    $imageTmpPath = $_FILES['image']['tmp_name'];
    $imageName = $_FILES['image']['name'];
    $imageExtension = pathinfo($imageName, PATHINFO_EXTENSION);

    // Specify the directory where the file is going to be placed
    $uploadDir = 'C:/Users/ACER/AndroidStudioProjects/project_akhir_tpm_123210073/images/';
    // Allow certain file formats
    $allowedfileExtensions = array('jpg', 'jpeg', 'png', 'gif');

    if (!in_array($imageExtension, $allowedfileExtensions)) {
        echo json_encode("Invalid file format");
        exit();
    }

    // Create a unique name for the image
    $newImageName = md5(time() . $imageName) . '.' . $imageExtension;
    $destPath = $uploadDir . $newImageName;

    if (move_uploaded_file($imageTmpPath, $destPath)) {
        $imagePath = $newImageName;
    } else {
        echo json_encode("Error uploading image");
        exit();
    }
}

// Insert user into the database
$hashedPassword = md5($password);
$insert = "INSERT INTO user (username, password, image, status) VALUES ('$username', '$hashedPassword', '$imagePath', 'Belum Premium')";
$query = mysqli_query($db, $insert);

if ($query) {
    echo json_encode("Success");
} else {
    echo json_encode("Error");
}

mysqli_close($db);
?>

<?php
$db = mysqli_connect('localhost', 'root', '', 'project_tpm');

$username = $_POST['username'];
$password = $_POST['password'];

$sql = "SELECT * FROM user WHERE username = '".$username."' AND password = '".md5($password)."'";

$result = mysqli_query($db, $sql);
$count = mysqli_num_rows($result);

if ($count == 1) {
    echo json_encode("Success");
} else {
    echo json_encode("Error");
}
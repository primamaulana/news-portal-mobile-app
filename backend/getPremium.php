<?php
$db = mysqli_connect('localhost', 'root', '', 'project_tpm');

$username = $_POST['username'];
$status = $_POST['status'];

$sql = "UPDATE user SET status = '".$status."' WHERE username = '".$username."'";

$result = mysqli_query($db, $sql);

echo json_encode("Success");

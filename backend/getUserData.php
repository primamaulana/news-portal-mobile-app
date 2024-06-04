<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "project_tpm";

$db = mysqli_connect('localhost', 'root', '', 'project_tpm');

$username = $_POST['username'];
if (!$db) {
    die("Connection failed: " . mysqli_connect_error());
  }
  
  $s = mysqli_query($db,"SELECT * FROM user WHERE username = '".$username."'");
  
  $return_arr = array();
  
  while ($row = mysqli_fetch_array($s)) {
      $row_array['image'] = $row['image'];
      $row_array['status'] = $row['status'];
      array_push($return_arr,$row_array);
  }
  
  echo json_encode($return_arr);
?>
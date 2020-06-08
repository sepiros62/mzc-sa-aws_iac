<?php
$servername = "abc-aurora-cluster.cluster-crm2u1irmmgo.ap-northeast-2.rds.amazonaws.com";
$username = "admin";
$password = "cdnadmin";
$db = "abcdb";
// Create connection
$conn = mysqli_connect($servername, $username, $password);
// Check connection
if (!$conn) {
  die("Connection failed: " . mysqli_connect_error());
}
echo "Installation Success! & Aurora Connection Success!";
?>

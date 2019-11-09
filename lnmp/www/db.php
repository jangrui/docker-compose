<?php
/*
try{
 $con =new PDO("mysql:host=mysql;dbname=test","root","123456");
 echo"ok...";

}catch(PDOException $e){

  echo $e->getMessage();
}
*/

  // $con = new mysqli("mysql","root","123456");

  // if($con->connect_error){
  //     die("connect fail".$con->connect_error);
  // }else{
  //     echo "connect success!";
  // }

$link = new mysqli("mysql", "root", "root", null);
if (!$link->connect_error) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}
echo "Success: A proper connection to MySQL was made! The docker database is great." . PHP_EOL;
echo "Host information: " . mysqli_get_host_info($link) . PHP_EOL;
mysqli_close($link);

<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("credits", $VALUE);

$fpa = fopen('/var/www/html/credits.txt', 'w');
fwrite($fpa, "Credits set to: $VALUE");
fclose($fpa);

echo "Number of credits awarded for valid share set to $VALUE";
?>

<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("limit_rate_up", $VALUE);

echo "Download Speed limit set to $VALUE kB/s";
?>

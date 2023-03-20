<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("in_peers", $VALUE);
echo "Number of inbound connections limited to $VALUE";
?>

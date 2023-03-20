<?php
include_once('./common.php');
$VALUE = $_POST["value"];
putvar("out_peers", $VALUE);


echo "Number of outbound connections limited to $VALUE";
?>

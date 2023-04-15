<?php

$config = '/home/nodo/variables/config.json';

function getvar($key)
{
    global $config;
    $fp = fopen($config, 'rw');
    $jn = fread($fp, filesize($fp));
    $dec = json_decode($jn);
    fclose($fp);
    if ($dec !== null) {
        return $dec[$key];
    }
    return null;
}

function putvar($key, $value)
{
    global $config;
    $fp = fopen($config, 'rw');
    $jn = fread($fp, filesize($fp));
    $dec = json_decode($jn);
    if ($dec !== null) {
        $dec[$key] = $value;
        fwrite($fp, json_encode($dec));
    }
    fclose($fp);
    return $value; // convenience
}

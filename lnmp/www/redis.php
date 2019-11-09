<?php

$redis = new Redis();
$redis->connect('redis',6379);
$redis->set('test','Success: A proper connection to Redis was made! The docker database is great!');
echo $redis->get('test');

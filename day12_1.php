<?php
echo sum_numbers(json_decode(file_get_contents('input'))), PHP_EOL;
echo sum_numbers(json_decode(file_get_contents('input')), true), PHP_EOL;
//run_tests();

function sum_numbers($root, $ignore_red = false)
{
	$sum = 0;
	foreach($root as $k => $v)
	{
		if(is_object($v))
		{
			if(!$ignore_red)
			{
				$sum += sum_numbers($v, $ignore_red);
			}
			else
			{
				$ignore = in_array('red', (array) $v, true);
				if($ignore === false)
					$sum += sum_numbers($v, $ignore_red);
			}
		}
		else if(is_array($v))
		{
			$sum += sum_numbers($v, $ignore_red);
		}
		else if(is_numeric($v))
		{
			$sum += $v;
		}
	}
	return $sum;
}

//rudimentary test suite
function run_tests()
{
	$jsons = ['[1,2,3]', '{"a":2,"b":4, "c":"lol"}', '[[[3]]]', '{"a":{"b":4},"c":-1}', '{"a":[-1,1]}', '[-1,{"a":1}]', '[]', '{}'];
	$sums = [6, 6, 3, 3, 0, 0, 0, 0];
	foreach($jsons as $index => $json)
		var_dump(sum_numbers(json_decode($json)) === $sums[$index]);

	$jsons = ['[1,2,3]', '[1,{"c":"red","b":2},3]', '{"root": {"d":"red","e":[1,2,3,4],"f":5}}', '[1,"red",5]'];
	$sums = [6, 4, 0, 6];
	foreach($jsons as $index => $json)
		var_dump(sum_numbers(json_decode($json), true) === $sums[$index]);
}

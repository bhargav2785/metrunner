<?php

ini_set('memory_limit', -1);

$globalSites = file('sites.txt', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);

foreach (glob('results/*.json') as $resultFilePath) {
	$data    = json_decode(file_get_contents($resultFilePath), true);
	$testUrl = "{$data['data']['testUrl']}";

	foreach ($globalSites as $index => $globalSite) {
		if (false !== strpos(strtolower($globalSite), strtolower($testUrl))) {
			$rank                 = ($index + 1);
			$data['data']['rank'] = $rank;
			file_put_contents($resultFilePath, json_encode($data, JSON_FORCE_OBJECT | JSON_PRETTY_PRINT));

			echo "{$testUrl} ranks at " . $rank . "\n";
			break;
		}
	}

	$data = null;
}
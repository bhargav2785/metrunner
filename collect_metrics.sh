#!/bin/bash

rm -f ${METRICS_CSV_FILE}

CL_METRICS="loadTime TTFB bytesOut bytesOutDoc bytesIn bytesInDoc connections requests requestsFull requestsDoc responses_200 responses_404 responses_other render fullyLoaded docTime score_cache score_cdn score_gzip score_keep-alive score_combine score_compress gzip_total gzip_savings image_total image_savings domElements titleTime loadEventStart loadEventEnd domContentLoadedEventStart domContentLoadedEventEnd lastVisualChange server_count server_rtt fixed_viewport score_progressive_jpeg firstPaint docCPUms fullyLoadedCPUms docCPUpct fullyLoadedCPUpct browser_process_count browser_main_memory_kb browser_other_private_memory_kb browser_working_set_kb SpeedIndex visualComplete chromeUserTiming.fetchStart chromeUserTiming.redirectStart chromeUserTiming.redirectEnd chromeUserTiming.unloadEventStart chromeUserTiming.unloadEventEnd chromeUserTiming.domLoading chromeUserTiming.responseEnd chromeUserTiming.firstLayout chromeUserTiming.firstPaint chromeUserTiming.firstTextPaint chromeUserTiming.firstImagePaint chromeUserTiming.domInteractive chromeUserTiming.domContentLoadedEventStart chromeUserTiming.domContentLoadedEventEnd chromeUserTiming.domComplete chromeUserTiming.loadEventStart chromeUserTiming.loadEventEnd effectiveBps effectiveBpsDoc";

echo "Rank,Website,"${CL_METRICS} | tr ' ' ',' >> ${METRICS_CSV_FILE};

for file in `ls ${RESULTS_DIR}/*.json`;
do
	RANK=$( cat ${file} | jq ".data.rank");
	TEST_URL=$( cat ${file} | jq ".data.testUrl" | tr -d '\' );

	consolePrint "processing ${TEST_URL}....";

	FIRST_VIEW=$( cat ${file} | jq ".data.average.firstView" );
	VALUES="";
	for metric in ${CL_METRICS};
	do
		METRIC_VALUE=$( echo ${FIRST_VIEW} | jq ".[\"${metric}\"]" );
		VALUES="${VALUES}${METRIC_VALUE},";
	done
	echo ${RANK},${TEST_URL},${VALUES} >> ${METRICS_CSV_FILE};
done
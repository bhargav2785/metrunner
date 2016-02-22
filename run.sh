#!/bin/bash

# ./run.sh
# ./run.sh mobile
# ./run.sh desktop

source variables.sh
source functions.sh

consolePrint "Start time: `date`"

printHeader "Checking dependencies....";
check_dependency webpagetest "https://github.com/marcelduran/webpagetest-api or run (npm install webpagetest -g)"
check_dependency jq "https://stedolan.github.io/jq/download/ or run (brew install jq)"
check_dependency curl "https://curl.haxx.se/docs/manpage.html or run (brew install curl)"
check_dependency php "http://php.net/manual/en/install.php or run (brew install php)"
check_dependency csvjson "http://csvkit.readthedocs.org/en/0.9.1/install.html or run (pip install csvkit)"
check_dependency pup "https://github.com/ericchiang/pup or run (brew install https://raw.githubusercontent.com/EricChiang/pup/master/pup.rb)"

if [ ${DEPENDENCIES_RESOLVED} != true ]; then
	printError "Please resolve all dependencies listed above"
	exit
fi

if [ "" = "$1" ]; then
	RUN_TYPE="${RUN_TYPE_DESKTOP}";
elif [ "${RUN_TYPE_MOBILE}" != "$1" ] && [ "${RUN_TYPE_DESKTOP}" != "$1" ]; then
	printError "'$1' is not a valid run type. Please use either '${RUN_TYPE_MOBILE}' or '${RUN_TYPE_DESKTOP}'";
else
	RUN_TYPE="$1";
fi

printHeader "Crawling top 500 sites for '${RUN_TYPE}'....";
source crawl_top_sites.sh

printHeader "Requesting tests....";
sleep 5
source request.sh "${RUN_TYPE}"

printHeader "Sleeping for 10 minutes....";
sleep 240
consolePrint "4/10 minutes elapsed"
sleep 240
consolePrint "8/10 minutes elapsed"
sleep 120
consolePrint "10/10 minutes elapsed"

printHeader "Checking the status of tests....";
source check_status.sh

printHeader "Downloading results....";
sleep 5
source download_results.sh

printHeader "Assigning ranks....";
sleep 5
php assign_rank.php

if [ ${RUN_TYPE} = ${RUN_TYPE_MOBILE} ]; then
	printHeader "Finding mobile data usage costs....";
	sleep 5
	source cost_finder.sh
fi

printHeader "Collecting metrics....";
sleep 5
source collect_metrics.sh

printHeader "Creating the final ${METRICS_JSON_FILE} file....";
sleep 5
mkdir -p ${METRICS_DIR}
csvjson -i 4 ${METRICS_CSV_FILE} > ${METRICS_DIR}/`date "+%Y.%m.%d"`."${RUN_TYPE}".${METRICS_JSON_FILE}

if [ ${RUN_TYPE} = ${RUN_TYPE_MOBILE} ]; then
	printHeader "Creating the final ${PRICES_JSON_FILE} file....";
	sleep 5
	mkdir -p ${PRICES_DIR}
	csvjson -i 4 ${PRICES_CSV_FILE} > ${PRICES_DIR}/`date "+%Y.%m.%d"`."${RUN_TYPE}".${PRICES_JSON_FILE}
fi

consolePrint "Done"
consolePrint "End time: `date`"
#!/bin/bash

rm -rf ${REQUESTS_DIR}
mkdir ${REQUESTS_DIR}

COUNTER=0;

RUN_TYPE_OPTION=""
if [ "$1" = ${RUN_TYPE_MOBILE} ]; then
	RUN_TYPE_OPTION="--mobile"
fi

for site in `cat ${SITES_FILE}`;
do
	COUNTER=`expr ${COUNTER} + 1`;

	if [ ${COUNTER} -le 200 ]; then
		WPT_KEY=${WPT_KEY1};
	elif [ ${COUNTER} -le 400 ]; then
		WPT_KEY=${WPT_KEY2};
	else
		WPT_KEY=${WPT_KEY3};
	fi

	filename=$(echo ${site} | cut -d'/' -f3).json;
	webpagetest test ${site} --key ${WPT_KEY} --connectivity Cable --keepua --breakdown --domains --pagespeed --first ${RUN_TYPE_OPTION} > ${REQUESTS_DIR}/${filename}
	statusCode=$(cat ${REQUESTS_DIR}/${filename} | jq '.statusCode');
	consolePrint "processed ${site} with ${statusCode}";
done
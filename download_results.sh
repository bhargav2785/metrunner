#!/bin/bash

rm -rf ${RESULTS_DIR}
mkdir ${RESULTS_DIR}

for i in ${REQUESTS_DIR}/*.json;
do
	testId=$(cat ${i} | jq -r '.data .testId');
	consolePrint "downloading ${testId}";
	webpagetest results ${testId} > ${RESULTS_DIR}/${testId}.json;
done

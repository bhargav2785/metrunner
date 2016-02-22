#!/bin/bash

for i in ${REQUESTS_DIR}/*.json;
do
	testId=$(cat ${i} | jq -r '.data .testId');
	test_status=$( webpagetest status ${testId} | jq -r '.statusText' );
	consolePrint "${testId} ${test_status}";
done
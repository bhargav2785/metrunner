#!/bin/bash

CF_NEED_HEADER=true;

rm -f ${PRICES_CSV_FILE}
rm -f ${PRICES_JSON_FILE}

for site in `ls ${RESULTS_DIR}/*.json`;
do
	consolePrint "processing ${site}";
	testUrl=$(cat ${site} | jq -r '.data.testUrl');
	rank=$(cat ${site} | jq -r '.data.rank');
	testId=$(echo ${site} | cut -d'/' -f2 | cut -d'.' -f1);
	html=$(curl -s "https://whatdoesmysitecost.com/test/${testId}");

	# Write header
	if [ ${CF_NEED_HEADER} = true ];then
		HEADER=$(echo ${html} | pup 'div#usdCost .postpaid.active.dataType table.results tr json{}' | jq -r '.[].children[0].text' | sed 1d | tr -d '$' | tr ',' ':' | tr '\n' ',');
		echo "Rank,Website,${HEADER}" >> ${PRICES_CSV_FILE};
		CF_NEED_HEADER=false;
	fi

	prices=$(echo ${html} | pup 'div#usdCost .postpaid.active.dataType table.results tr json{}' | jq -r '.[] .children[1].children[0].text' | sed 1d | tr -d '$' | tr ',' ':' | tr '\n' ',');
	echo ${rank},${testUrl},${prices} >> ${PRICES_CSV_FILE};
done
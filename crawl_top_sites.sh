#!/bin/bash

rm -f ${SITES_FILE}

for i in `seq 0 19`;
do
	page="`expr ${i} + 1`/20"
	consolePrint "processing page ${page}"
	sites=$( curl -s "http://www.alexa.com/topsites/global;${i}" | pup --color ".listings .site-listing .desc-container .desc-paragraph a text{}" );
	for site in ${sites};
	do
		consolePrintSimple "http://www.${site}" >> ${SITES_FILE}
	done
done
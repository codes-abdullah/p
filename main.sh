#!/usr/bin/bash

################################## vars
let date_line=9
let date_line_diff=10
let forecast_offset=4
let forecast_line=$((date_line + forecast_offset))
#noon = 2
let target_timing_offset=2
sep="-------------------------------------------------------------------------"
log="./log.txt"
echo "working, please wait..."
weather="tmp.txt"

################################## initial log file
if test ! -f $log; then
	echo $sep >> $log
	echo -e "year\t|\tmonth\t|\tday\t|\tobs_tmp\t|\tfc_temp" >> $log
fi

################################## write forecasted weather to file
curl --silent -o $weather wttr.in/casablanca
if [[ "$?" -ne 0 ]]; then
	echo "failed to fetch data from wttr.in"
	exit 1
fi

################################## get actual temp
actual_temp=`curl --silent wttr.in/casablanca?format=%t`
if [[ "$?" -ne 0 ]]; then
	echo "failed to fetch data from wttr.in"
	exit 1
fi
actual_temp=`echo $actual_temp | grep -ohP '\d+'`

################################## extract data from forecasted file
for i in {0..2}; do
	v=`head -n ${date_line} $weather | tail -n 1` && v=${v#* } && v=${v#* } && v=${v% *} && IFS=' ' read -r -a arr <<< "$v"
	year=`date +%Y`
	day=${arr[1]}
	month=${arr[2]}
	if [[ `date +%d` == "${day}" ]]; then
		forecast_temp="`head -n ${forecast_line} $weather | tail -n 1 | grep -ohP "\+\d+" | head -n $target_timing_offset | tail -n 1`"
		forecast_temp=`echo $forecast_temp | grep -ohP "\d+"`
		break;
	fi
	
	
	let date_line=$((date_line + date_line_diff))
	let forecast_line=$((date_line + forecast_offset))
done

################################## write the report to log file
echo $sep >> $log
echo -e "${year}\t|\t${month}\t|\t${day}\t|\t${actual_temp}\t|\t${forecast_temp}" >> $log
echo "done, written to $log"

################################## analyze report file
./analyze.sh


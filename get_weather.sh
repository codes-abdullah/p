#!/usr/bin/bash


let date_line=9
let date_line_diff=10
let forecast_offset=4
let forecast_line=$((date_line + forecast_offset))
#noon = 2
let target_timing_offset=2
sep="-------------------------------------------------------------------------"
report="./report.txt"
echo "working, please wait..."

if test ! -f $report; then
	echo $sep >> $report
	echo -e "year\t|\tmonth\t|\tday\t|\tobs_tmp\t|\tfc_temp" >> $report
fi

curl --silent -o file wttr.in/casablanca
if [[ "$?" -ne 0 ]]; then
	echo "failed to fetch data from wttr.in"
	exit 1
fi
 

for i in {0..2}; do
	v=`head -n ${date_line} file | tail -n 1` && v=${v#* } && v=${v#* } && v=${v% *} && IFS=' ' read -r -a arr <<< "$v"
	year=`date +%Y`
	day=${arr[1]}
	month=${arr[2]}
	if [[ `date +%d` == "${day}" ]]; then
		forecast_temp="`head -n ${forecast_line} file | tail -n 1 | grep -ohP "\+\d+" | head -n $target_timing_offset | tail -n 1`"
		forecast_temp=`echo $forecast_temp | grep -ohP "\d+"`
		break;
	fi
	
	
	let date_line=$((date_line + date_line_diff))
	let forecast_line=$((date_line + forecast_offset))
done


actual_temp=`curl --silent wttr.in/casablanca?format=%t`
if [[ "$?" -ne 0 ]]; then
	echo "failed to fetch data from wttr.in"
	exit 1
fi


actual_temp=`echo $actual_temp | grep -ohP '\d+'`

echo $sep >> $report
echo -e "${year}\t|\t${month}\t|\t${day}\t|\t${actual_temp}\t|\t${forecast_temp}" >> $report

echo "done, written to $report"

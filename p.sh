#!/usr/bin/bash


let date_line=9
let date_line_diff=10
let forecast_offset=4
let forecast_line=$((date_line + forecast_offset))
let target_timing_offset=2
 

for i in {0..2}; do
	v=`head -n ${date_line} file | tail -n 1` && v=${v#* } && v=${v#* } && v=${v% *} | arr=($v)	
	year=`date +%Y`
	day=${arr[1]}
	month=${arr[2]}
	if [[ `date +%y` != "${day}" ]]; then echo "no equals: ${month}"; continue; fi
	
	
	let date_line=$((date_line + date_line_diff))
	let forecast_line=$((date_line + forecast_offset))
	echo "${date_line} && ${forecast_line}"
	break;
done


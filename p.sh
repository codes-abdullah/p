#!/usr/bin/bash


let date_line=9
let date_line_diff=10
let forecast_offset=4
let forecast_line=$((date_line + forecast_offset))
#noon = 2
let target_timing_offset=2

 

for i in {0..2}; do
	v=`head -n ${date_line} file | tail -n 1` && v=${v#* } && v=${v#* } && v=${v% *} && IFS=' ' read -r -a arr <<< "$v"
	year=`date +%Y`
	day=${arr[1]}
	month=${arr[2]}
	if [[ `date +%d` == "${day}" ]]; then
		forecast_temp="`head -n ${forecast_line} file | tail -n 1 | grep -ohP "\+\d+" | head -n $target_timing_offset | tail -n 1`"
		break;
	fi
	
	
	let date_line=$((date_line + date_line_diff))
	let forecast_line=$((date_line + forecast_offset))
done

actual_temp="10"
echo "${year} - ${month} - ${day} - ${actual_temp} - ${forecast_temp}"

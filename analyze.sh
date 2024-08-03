#!/usr/bin/bash




lines=`tail -n +4 log.txt`



let max=0
let min=1000
min_date=""
max_date=""

while IFS= read -e l; do
	arr=(${l//|/ })
		
	if (( max < arr[3] )); then
		max=${arr[3]}
		max_date="${arr[0]} ${arr[1]} ${arr[2]}"
	fi
	
	
	if (( min > arr[3] )); then
		min=${arr[3]}
		min_date="${arr[0]} ${arr[1]} ${arr[2]}"
	fi
	
done <<< "$lines";

echo "min: ${min}°C on ${min_date}"
echo "max: ${max}°C on ${max_date}"

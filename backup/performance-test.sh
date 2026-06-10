#!/bin/bash

URL="http://10.10.10.166:8080/hello"
TOTAL_REQUESTS=100
THRESHOLD=1.0  # 1 second

echo "Running $TOTAL_REQUESTS requests to $URL ..."

# Run 100 requests and store times
times=()
for i in $(seq 1 $TOTAL_REQUESTS)
do
    start=$(date +%s.%N)
    curl -s $URL > /dev/null
    end=$(date +%s.%N)
    diff=$(echo "$end - $start" | bc)
    times+=($diff)
done

# Calculate average
sum=0
for t in "${times[@]}"
do
    sum=$(echo "$sum + $t" | bc)
done
avg=$(echo "$sum / $TOTAL_REQUESTS" | bc -l)

echo "Average response time: $avg seconds"

# Check threshold
result=$(echo "$avg < $THRESHOLD" | bc)
if [ $result -eq 1 ]; then
    echo "Performance test PASSED"
    exit 0
else
    echo "Performance test FAILED"
    exit 1
fi
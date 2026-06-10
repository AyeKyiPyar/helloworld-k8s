```bash
#!/bin/bash

URL="http://localhost:8080/hello"
REQUESTS=100
TOTAL_TIME=0

echo "Running $REQUESTS requests to $URL ..."

for i in $(seq 1 $REQUESTS)
do
    # Measure response time in seconds
    RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" $URL)

    echo "Request $i: ${RESPONSE_TIME}s"

    # Add response time
    TOTAL_TIME=$(awk "BEGIN {print $TOTAL_TIME + $RESPONSE_TIME}")
done

# Calculate average
AVERAGE=$(awk "BEGIN {print $TOTAL_TIME / $REQUESTS}")

echo "--------------------------------"
echo "Average response time: ${AVERAGE}s"

# Check performance
if awk "BEGIN {exit !($AVERAGE < 1)}"
then
    echo "✅ Performance Test PASSED (Average < 1 second)"
    exit 0
else
    echo "❌ Performance Test FAILED (Average >= 1 second)"
    exit 1
fi
```

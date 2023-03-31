#!/bin/sh
# Set the threshold for the maximum number of containers allowed
THRESHOLD=50

# Get the current number of running containers in the cluster
CURRENT_COUNT=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running | grep -v NAME | wc -l)

# Compare the current count to the threshold and exit with the appropriate code
if [ $CURRENT_COUNT -gt $THRESHOLD ]
then
    echo "Too many running containers in the cluster! (Current count: $CURRENT_COUNT)"
    exit 1
else
    echo "Number of running containers in the cluster is within acceptable limits. (Current count: $CURRENT_COUNT)"
    exit 0
fi

#!/bin/sh
export TASK_IP_ADDRESS=$(curl ${ECS_CONTAINER_METADATA_URI_V4} | jq ".Networks[0].IPv4Addresses[0]")
echo "Task ip: $TASK_IP_ADDRESS"
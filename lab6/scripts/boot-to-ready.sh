#!/usr/bin/env bash
set -euo pipefail

INSTANCE_ID="${1:?Usage: $0 INSTANCE_ID}"
REGION="us-east-1"
TIMEOUT=300
INTERVAL=5

START=$(date +%s)

echo "Instance: $INSTANCE_ID"
echo "Waiting for HTTP 200..."

while true; do
  IP=$(aws ec2 describe-instances \
    --region "$REGION" \
    --instance-ids "$INSTANCE_ID" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

  if [[ "$IP" != "None" && -n "$IP" ]]; then
    STATUS=$(curl -s -o /dev/null -w '%{http_code}' \
      --connect-timeout 3 --max-time 5 \
      "http://$IP" || true)

    if [[ "$STATUS" == "200" ]]; then
      END=$(date +%s)
      echo "HTTP status: 200"
      echo "Public IP: $IP"
      echo "Time to ready: $((END - START)) seconds"
      exit 0
    fi
  fi

  NOW=$(date +%s)

  if (( NOW - START >= TIMEOUT )); then
    echo "Timeout: HTTP 200 not received within $TIMEOUT seconds"
    exit 1
  fi

  sleep "$INTERVAL"
done

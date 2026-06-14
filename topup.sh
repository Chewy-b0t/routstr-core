#!/bin/bash
# Top up Routstr account with Lightning invoice
# Usage: ./topup.sh <amount_sats>

AMOUNT=${1:-100}

echo "Creating Lightning invoice for $AMOUNT sats..."
INVOICE=$(curl -s -X POST http://127.0.0.1:8000/lightning/invoice \
  -H "Content-Type: application/json" \
  -d "{\"amount_sats\":$AMOUNT}")

echo "$INVOICE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(f'Invoice ID: {data[\"invoice_id\"]}')
print(f'Bolt11: {data[\"bolt11\"]}')
print(f'Amount: {data[\"amount_sats\"]} sats')
print(f'Expires: {data[\"expires_at\"]}')
print()
print('Pay this invoice with any Lightning wallet:')
print(data['bolt11'])
print()
print(f'Check status: curl http://127.0.0.1:8000/lightning/invoice/{data[\"invoice_id\"]}/status')
"

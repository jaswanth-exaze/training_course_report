#!/bin/bash

TITLE="$1"
AMOUNT="$2"
CATEGORY="$3"

if [ -z "$TITLE" ] || [ -z "$AMOUNT" ]; then
  echo "Usage: ./add_expense.sh \"Title\" amount \"Category\""
  exit 1
fi

psql "postgres://postgres:password@127.0.0.1:5432/expense" -c \
"INSERT INTO expenses (title, amount, category) VALUES ('$TITLE', $AMOUNT, '$CATEGORY');"


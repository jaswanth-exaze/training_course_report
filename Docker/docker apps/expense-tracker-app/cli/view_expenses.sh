#!/bin/bash

# View the 10 most recent expenses from PostgreSQL
# Using your PostgreSQL credentials

psql "postgres://postgres:password@127.0.0.1:5432/expense" -c \
"SELECT id, title, amount, category, created_at
 FROM expenses
 ORDER BY created_at DESC
 LIMIT 10;"

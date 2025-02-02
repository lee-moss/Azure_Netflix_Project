#!/bin/bash

# Read the API key from .env file
TMDB_API_KEY=$(grep TMDB_API_KEY .env | cut -d '=' -f2)

# Replace the placeholder in script.js with actual API key
sed "s/\${TMDB_API_KEY}/$TMDB_API_KEY/" script.js > script.tmp.js
mv script.tmp.js script.js 
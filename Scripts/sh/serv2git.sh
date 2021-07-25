#!/bin/bash

cd /root/GitHub/VIP
git add .
git commit -m "🤖️sync $(date +%Y-%m-%d" "%H:%M:%S)"
git push -u origin main
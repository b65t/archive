#!/bin/sh

printf "%.0f\n" $(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

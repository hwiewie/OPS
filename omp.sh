#!/bin/bash
#
#取得TargetID
omp -u admin -w password -T | awk '/T*-IP$/ {print $1}'
#取得TaskID
omp -u admin -w password -G | awk '/T*-Weekly-Scan$/ {print $1}'

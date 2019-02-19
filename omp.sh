#!/bin/bash
#
#取得TargetID
omp -u admin -w password -T | awk '/T*-IP$/ {print $1}'
#取得TaskID
omp -u admin -w password -G | awk '/T*-Weekly-Scan$/ {print $1}'
#取得ReportID
omp -u admin -w password -G 72b3cb8f-f044-41d5-8dce-cfbfaefff537 | awk '/T*-Weekly-Scan/{getline; print}' | awk '/ Done / {print $1}'

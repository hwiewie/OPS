#!/bin/bash
#
#取得TargetID
omp -u admin -w password -T | awk '/T*-IP$/ {print $1}'
#取得TaskID
omp -u admin -w password -G | awk '/T*-Weekly-Scan$/ {print $1}'
#取得ReportID
omp -u admin -w password -G 72b3cb8f-f044-41d5-8dce-cfbfaefff537 | awk '/T*-Weekly-Scan/{getline; print}' | awk '/ Done / {print $1}'
#取得FormatID
omp -u admin -w password -F | awk '/  XML$/ {print $1}'
#取得Report
omp -u admin -w password -R 5dd0caaf-3bf6-495e-9a3e-d4aed84dad97 -f a994b278-1f62-11e1-96ac-406186ea4fc5 > /home/report.xml

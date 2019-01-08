#https://raw.githubusercontent.com/liamosaur/nmap-parser-xml-to-csv/master/nmap-parser-xml-to-csv.py
#scan ip list : all.txt
#scan repot : result.xml
#convert to csv : report.csv
#crontab -e : 20 9 * * 1 schedulescan.sh
cd /root/portscan
rm result.xml
nmap -p- -T4 -iL all.txt -oX result.xml
rm report.csv
python nmap-parser-xml-to-csv.py result.xml -s , -o report.csv

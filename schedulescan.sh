#https://raw.githubusercontent.com/laconicwolf/Nmap-Scan-to-CSV/master/nmap_xml_parser.py
#scan ip list : all.txt
#scan repot : result.xml
#convert to csv : report.csv
#crontab -e : 20 9 * * 1 schedulescan.sh
cd /root/portscan
rm result.xml
nmap -p- -T4 -iL all.txt -oX result.xml
rm report.csv
python nmap_xml_parser.py -f result.xml -csv report.csv

#https://raw.githubusercontent.com/liamosaur/nmap-parser-xml-to-csv/master/nmap-parser-xml-to-csv.py
#scan ip list : all.txt
#scan repot : result.xml
#convert to csv : report.csv
#crontab -e : 20 9 * * 1 schedulescan.sh
rm -rf discovery.gnmap
nmap -sn -T4 -iL all.txt -oG discovery.gnmap
rm -rf livehost.txt
grep "Status: Up" discovery.gnmap | cut -f 2 -d" " > livehost.txt
rm -rf result.xml
#nmap -p- -T4 -iL livehost.txt -oX result.xml
#rm report.csv
#python nmap-parser-xml-to-csv.py result.xml -s , -o report.csv
#nmap -sS -T4 -Pn -oG TopTCP -iL livehost.txt
#nmap -sU -T4 -Pn -oN TopUDP -iL livehost.txt
sudo nmap -sS -T4 -Pn -p- -iL livehost.txt -oX result.xml
#grep “open” FullTCP|cut -f 1 -d ‘ ‘ | sort -nu | cut -f 1 -d ‘/’ |xargs | sed ‘s/ /,/g’|awk ‘{print “T:”$0}’
rm -rf report.csv
python nmap-parser-xml-to-csv.py result.xml -s , -o report.csv

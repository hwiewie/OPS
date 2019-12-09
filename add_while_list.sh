mv today.txt old.txt
mv total.txt today.txt
cat total.txt 20191203.txt 20191203.txt | sort | uniq -u
cat 20191203.txt today.txt today.txt | sort | uniq -u
cat today.txt 20191203.txt | sort | uniq > total.txt
cat total.txt | ./cidr.py > result.txt
cat today.txt | ./cidr.py > temp.txt 
cat result.txt temp.txt | sort | uniq -u  
cat result.txt temp.txt temp.txt| sort | uniq -u
awk BEGIN{RS=EOF}'{gsub(/\n/," or src net ");print}' aaa.txt

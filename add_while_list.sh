mv today.txt old.txt
mv total.txt today.txt
//cat news.txt today.txt today.txt | sort | uniq -u
cat today.txt news.txt | sort | uniq > total.txt
cat total.txt | ./cidr.py > result.txt
cat today.txt | ./cidr.py > temp.txt 
cat result.txt temp.txt | sort | uniq -u  > aaa.txt
//cat result.txt temp.txt temp.txt| sort | uniq -u
awk BEGIN{RS=EOF}'{gsub(/\n/," or src net ");print}' aaa.txt

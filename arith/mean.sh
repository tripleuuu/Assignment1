#!/bin/bash
#This script is for obtaing the result of mean(ie. gene expression)
#obtain the gene name 
IFS="\t"
mkdir ./mean_output
cut -f4 TriTrypDB-46_TcongolenseIL3000_2019.bed > ./interfile/genename.txt
if [ "$l" = "all" ]; then
mkdir ./mean_output/$i/$var1  
 for genename in ./interfile/genename.txt 
 do
 echo -e "This\tis\toutput\tof\tgroup\t{$i}.{$var1}\t" > ./mean_output/$i/$var1/mean.txt
 echo -e "genename\tmean(gene expression)\tdescription " >> ./mean_output/$i/$var1/mean.txt
 express=$(grep -wc "$genename" ./ali_output/$i/$var1/overlap$var1.bed)
 total=$(wc -l ./ali_output/$i/$var1/overlap$var1.bed)
 descri=$(grep $genename TriTrypDB-46_TcongolenseIL3000_2019.bed | cut -f5)         
 echo -e "$genename\t$express\t$descri" >> ./mean_output/$i/$var1/mean.txt
 done
else
mkdir ./mean_output/$i/$l
 for genename in ./interfile/genename.txt
 do
 echo -e "This\tis\toutput\tof\tgroup\t{$i}.{$l}" > ./mean_output/$i/$l/mean.txt
 echo -e "genename\tmean(gene expression)\tdescription " >> ./mean_output/$i/$l/mean.txt
 express=$(grep -wc "$genename" ./ali_output/$i/$l/overlap$l.bed)
 total=$(wc -l ./ali_output/$i/$l/overlap$l.bed)
 mean=$($express/$total)
 descri=$(grep $genename TriTrypDB-46_TcongolenseIL3000_2019.bed | cut -f5)
 echo -e "$genename\t$express\t$descri" >> ./mean_output/$i/$l/mean.txt
 done
fi
echo "Waiting for the output."
#sum all
cat ./mean_output/$i/*/*.txt > mean_all$i.txt
echo "Gene expression calculation has been done."

#obtain the fold change
if [ "$l" = "all" ]; then
mkdir ./foldchange/{$i}_{$var1}
 while read mean
 count=$((count++))
 echo -e "This\tis\tfold\tchange\tof\tgroup\t{$i}.{$var1}" > ./foldchange/{$i}_{$var1}/chag.txt
 echo -e "genename\tfold change\tdescription " >> ./foldchange/{$i}_{$var1}/chag.txt
 exp1=$(cat mean_all$i.txt | grep -l $count)
 exp2=$(cat mean_all$i.txt | grep -l $count+1) 
 foldchange=$($exp1/$exp2)
 echo -e "$genename\t$foldchange\t$descri" >> ./mfoldchange/{$i}_{$var1}/chag.txt
 done < mean_all$i.txt
else
mkdir ./foldchange/{$i}_{$l}
 while read mean
  count=$((count++))
  echo -e "This\tis\tfold\tchange\tof\tgroup\t{$i}.{$var1}" > ./foldchange/{$i}_{$var1}/chag.txt
  echo -e "genename\tfold change\tdescription " >> ./foldchange/{$i}_{$var1}/chag.txt
  exp1=$(cat mean_all$i.txt | grep -l $count)
  exp2=$(cat mean_all$i.txt | grep -l $count+1)
  foldchange=$($exp1/$exp2)
  echo -e "$genename\t$foldchange\t$descri" >> ./mfoldchange/{$i}_{$var1}/chag.txt
 done < mean_all$i.txt
fi
echo "Mean calculation has been done."



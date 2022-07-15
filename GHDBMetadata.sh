#!/bin/bash
if [[ $1 = ""||$2 = "" ]]; then
echo "GHDB_Metadata by:Alt3r3ad1"
echo "Method for use: ./GHDBMetadata.sh 'target.com' 'extension_archive'"
else

lynx --dump "https://google.com/search?&q=site:$1+ext:$2" | grep ".$2" | cut -d "=" -f2 | egrep -v "site|google" | sed 's/...$//' | egrep "http://|https://" > GHDBMetadata.GHDB
for url in $(cat GHDBMetadata.GHDB);
do
wget -q $url;
done

$(find . -name "* *.$2" -type f -print0 | while read -d $'\0' f;
do
mv -v "$f" "${f// /_}";
done) 2> /dev/null

nameArchiveResult=$(echo $1 | cut -d '.' -f1)_$2.GHDB
rm -r $nameArchiveResult 2> /dev/null

metadata=0
for archive in $(find *.$2 2> /dev/null 2> /dev/null);
do
echo -e "\n**************$archive**************"
exiftool $archive 2> /dev/null
metadata=1
done > $nameArchiveResult

cat $nameArchiveResult 2> /dev/null

if [ $metadata = 1 ]; then
echo -e "\n***********************************************************"
echo "*******Info Metadata saved in directory the script*********"
echo "*************In archive : $nameArchiveResult*************"
echo "***********************************************************"
else
echo -e "\n***********************************************************"
echo "**********Archives for extension nothing found*************"
echo "***********************************************************"
rm -r $nameArchiveResult 2> /dev/null
fi
rm -r GHDBMetadata.GHDB *.$2 2> /dev/null
fi

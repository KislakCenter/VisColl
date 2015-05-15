#!/usr/bin/env bash

XSLTS="
xslts/process4.xsl
xslts/process5.xsl
xslts/process6-excel.xsl"

SUPPORT=`dirname $0`/support
# collation-to-html.xsl

index=0
tmp=${TMPDIR:-/tmp}/prog.$$
infile=$1
outfolder=`echo $infile | awk -F '_' '{ print $1 }'`
if [ -d $outfolder ]; then
rm -rf $outfolder
echo "Deleted existing folder $outfolder"
fi
for xsl in $XSLTS
do
	outfile=${tmp}_${index}
	/Users/dorp/bin/saxon -s:"$infile" -xsl:$xsl -o:$outfile
	echo "Wrote $outfile"
	infile=$outfile
	index=$(( $index + 1 ))
done

saxon -s:$infile -xsl:xslts/process7.xsl




#!/bin/bash

## \file
## \TODO This file implements a very trivial feature extraction; use it as a template for other front ends.
## 
## Please, read SPTK documentation and some papers in order to implement more advanced front ends.

# Base name for temporary files
base=/tmp/$(basename $0).$$ 

# Ensure cleanup of temporary files on exit
trap cleanup EXIT
cleanup() {
   \rm -f $base.*
}

if [[ $# != 5 ]]; then
   echo "$0 mfcc_order num_filters freq input.wav output.dyn"
   echo $1 $2 $3
   exit 1
fi

mfcc_order=$1
num_filters=$2
freq=$3 
inputfile=$4
outputfile=$5

UBUNTU_SPTK=1
if [[ $UBUNTU_SPTK == 1 ]]; then
   # In case you install SPTK using debian package (apt-get)
   X2X="sptk x2x"
   FRAME="sptk frame"
   WINDOW="sptk window"
   MFCC="sptk mfcc"
   DELTA="sptk delta"
else
   # or install SPTK building it from its source
   X2X="x2x"
   FRAME="frame"
   WINDOW="window"
   MFCC="mfcc"
   DELTA="delta"
fi


# Main command for feature extration
sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
	$MFCC -l 240 -m $mfcc_order -n $num_filters -s $freq > $base.mfcc
echo "-0.5 0 0.5" | $X2X +af > delta
echo "0.25 0 -0.5 0 0.25" | $X2X +af > accel
$DELTA -m $(($mfcc_order -1)) -d delta -d accel $base.mfcc > $base.dyn

# Our array files need a header with the number of cols and rows:
ncol=$((3*$mfcc_order)) # mfcc p =>  (gain a1 a2 ... ap) 
nrow=`$X2X +fa < $base.dyn | wc -l | perl -ne 'print $_/'$ncol', "\n";'`

# Build fmatrix file by placing nrow and ncol in front, and the data after them
echo $nrow $ncol | $X2X +aI > $outputfile
cat $base.dyn >> $outputfile

# Main command for feature extration
#sox $inputfile -t raw -e signed -b 16 - | $X2X +sf | $FRAME -l 240 -p 80 | $WINDOW -l 240 -L 240 |
#	$MFCC -l 240 -m $mfcc_order -n $num_filters -s $freq -E > $base.mfcc
#echo "-0.5 0 0.5" | $X2X +af > delta
#echo "0.25 0 -0.5 0 0.25" | $X2X +af > accel
#$DELTA -m $mfcc_order -d delta -d accel $base.mfcc > $base.dyn

# Our array files need a header with the number of cols and rows:
#ncol=$((3*$mfcc_order + 3)) # mfcc p =>  (gain a1 a2 ... ap) 
#nrow=`$X2X +fa < $base.dyn | wc -l | perl -ne 'print $_/'$ncol', "\n";'`

# Build fmatrix file by placing nrow and ncol in front, and the data after them
#echo $nrow $ncol | $X2X +aI > $outputfile
#cat $base.dyn >> $outputfile

#exit


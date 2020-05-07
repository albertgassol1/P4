#!/bin/bash
for filters in 20 24 28 32 36 40; do
    for ngauss in 5 6 7 8 9 10 11 12; do
        for coefs in 14 15 16 17 18 19 20 21 22 23 24 25; do
            folder="$filters$coefs"
            FEAT=mfcc run_spkid train $folder $ngauss
            FEAT=mfcc run_spkid test $folder 
            retval=$(FEAT=mfcc run_spkid classerr $folder)
            echo "coefs = " $coefs ", Nfilters = " $filters ", Ngauss = " $ngauss ", percent = " $retval >> results.txt
        done
    done
done
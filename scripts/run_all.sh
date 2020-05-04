#!/bin/bash
for coefs in 14 15 16 17 18; do
    run_spkid mfcc 18 24
    FEAT=mfcc run_spkid train
    FEAT=mfcc run_spkid test
    FEAT=mfcc run_spkid classerr
    echo "done"
    echo  "mfcc coefs = " $coefs>> results.txt 
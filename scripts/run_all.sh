#!/bin/bash
for coefs in 14 15 16 17 18; do
    run_spkid mfcc $coefs 24 $coefs
done
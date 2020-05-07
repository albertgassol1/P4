
for filters in 20 24 28 32 36 40; do
    for coefs in 14 15 16 17 18 19 20 21 22 23 24 25; do
        folder="$filters$coefs"
        run_spkid mfcc $coefs $filters $folder
    done
done
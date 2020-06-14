
coefs=20
filters=24
ngauss=20
ngaussworld=100
folder="$filters$coefs"
#run_spkid mcp $coefs $filters
FEAT=mfcc run_spkid_modified train $folder $ngauss
FEAT=mfcc run_spkid_modified trainworld $ngaussworld $folder
FEAT=mfcc run_spkid_modified verify $folder
retval=$(FEAT=mfcc run_spkid_modified verif_err)
echo "coefs = "$coefs ", ngauss train = " $ngauss ", filters = " $filters ", ngauss world = " $ngaussworld ", " $retval >> resultsVerify.txt


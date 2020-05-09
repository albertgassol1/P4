
coefs=16
filters=20
ngauss=20
ngaussworld=100

run_spkid mcp $coefs $filters
FEAT=mcp run_spkid train $ngauss
FEAT=mcp run_spkid trainworld $ngaussworld
FEAT=mcp run_spkid verify
retval=$(FEAT=mcp run_spkid verif_err)
echo "coefs = "$coefs ", ngauss train = " $ngauss ", filters = " $filters ", ngauss world = " $ngaussworld ", " $retval >> resultsVerify.txt

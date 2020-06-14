file = open("results.txt", 'r')

f = file.read()
lines = f.split('\n')
ntot = 0
nerr = 0

for line in lines:
  if line == '':
    break
  s = line.split('/')
  s1 = s[1]
  saux = s[2].split('\t')
  s2 = saux[1]
  ntot +=1

  if s1!=s2:
    nerr+=1

print("Nerr = ", nerr, ", Tot = ", ntot, ", Error Rate = ", (nerr/ntot)*100, "%")
  
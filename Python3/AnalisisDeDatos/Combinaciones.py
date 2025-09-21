import itertools

numeros = list(range(46))

combinaciones = itertools.combinations(numeros, 6)

with open("combinaciones.txt", "w") as f:
    for c in combinaciones:
        f.write(" ".join(f"{x:02d}" for x in c) + "/")

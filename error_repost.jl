using ITensors

ind1 = Index(2)
ind2 = Index(2)
A = ITensor([1,2,3,4],ind1,ind2)
x = ITensor([8,9],ind1)
print(A*x)

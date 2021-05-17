import sys
import function
from scipy.special import comb
from scipy import stats

conserved_file,module_file = sys.argv[1:]

conserved_obj = open(conserved_file,"r")
conserved_gene = []
for i in conserved_obj.readlines():
    conserved_gene.append(i.strip())
#把最保守的基因读到列表里面去
conserved_obj.close()
l = len(conserved_gene)

p = {}
module_obj = open(module_file,"r")
for line in module_obj.readlines():
    line = line.strip()
    linelist = line.split("\t")
    locals()[linelist[0]] = linelist[1:]
    n = len(locals()[linelist[0]])
    k = function.numbers_1in2(locals()[linelist[0]],conserved_gene)
    #n代表这个module有多少个基因
    #k代表这个module有多少个保守基因（前面输入的文件）
    #pvalue = (comb(1076,k)*comb(20438,n-k))/comb(21514,n)
    pvalue = stats.hypergeom.pmf(k,21514,l,n)
    #参数：1.目标集合中取出的个数，2.总个数，3.目标集合的个数，4.取的个数
    #超几何分布算p值
    p[linelist[0]] = pvalue
    if pvalue <= 0.01:
        print(linelist[0])
        for gene in linelist[1:]:
            print(gene)
module_obj.close()

#indicator = 0
#for i,j in p.items():
#    print(i+"\t"+str(j))
#    indicator+=1
#print(str(indicator))

#shannon entropy
import math
def entropy(list):
    sum = 0
    for i in list:
        sum += i 
    #calculate the sum of the inputed list
    #the expression level of genes in different samples generally are positive.
    
    entropy = 0
    p = []
    
    if sum == 0:
        entropy = -1
    # If genes in all samples do not express, the entropy would be -1.
    else:
        for i in list:
            p.append(i/sum)
    #p is the list including the frenquecy of each element
    
        for i in p:
            if i == 0:
                pass
            else:
                entropy += (-i*math.log(i,2))
    
    return entropy

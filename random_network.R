args<-commandArgs(T)
interact = read.table(args[1],sep="\t",header=FALSE)
interact = interact[c("V1","V2")]
colnames(interact) = c("Gene1","Gene2")

calculate_distance = function(matrix,l){
  matrix = as.vector(matrix)
  k = 0
  total = 0
  for(i in matrix){
    if(i != Inf){
      total = total+i
    }else{
      k = k + 1
    }
  }
  return(total/(l*(l-1)-k))
}

library("igraph")
g = graph_from_data_frame(d = interact,vertices = NULL,directed = F)
#只有载入edge的数据框的权重列名为weight才可以加入权重
#g = set_edge_attr(g, "weight", value= interact$Weight)
#否则只能手动加入权
dg = degree(g,mode="all")
all_gene = names(dg)
express = read.table(args[2],sep="\t",header=T)
tip = express$Gene.ID
tip_in_tissue = intersect(tip,all_gene)

all_shortest_distance = mean_distance(g,directed =FALSE,unconnected = TRUE)
#生成网络整体的平均最短路径
tip_distance_matrix = distances(g,v=tip_in_tissue,to =tip_in_tissue,
                         weights=NA, algorithm="automatic")
#生成TiP基因之间的最短距离矩阵
tip_distance = calculate_distance(tip_distance_matrix,length(tip_in_tissue))
#写函数，计算TiP基因之间的平均最短路径
real_network = c(all_shortest_distance,tip_distance)
names(real_network) = c("network mean distance","TiP genes mean distance")

random_tip_distance = c()
for(i in 1:1000){
  random_g = sample_degseq(dg,method = "vl") %>%
    set_vertex_attr("name", value=V(g)$name)
  #生成度控制随机网络,并给节点加上名称
  tip_distance_matrix = distances(random_g,v=tip_in_tissue,to =tip_in_tissue,
                                  weights=NA, algorithm="automatic")
  tip_distance = calculate_distance(tip_distance_matrix,length(tip_in_tissue))
  random_tip_distance = c(random_tip_distance,tip_distance)
}

print(real_network)
print(random_tip_distance)

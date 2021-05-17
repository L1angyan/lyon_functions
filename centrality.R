#setwd("D:/liangyan123/组织特异互作网络/igraph")
args<-commandArgs(T)
header = unlist(strsplit(args[1],split=".txt"))
interact = read.table(args[1],sep="\t")
#interact = interact[c("V1","V2","V7")]
colnames(interact) = c("Gene1","Gene2","weight")

library("igraph")
g = graph_from_data_frame(d = interact,vertices = NULL,directed = F)
#只有载入edge的数据框的权重列名为weight才可以加入权重
#g = set_edge_attr(g, "weight", value= interact$Weight)
#否则只能手动加入权重

#计算拓扑属性
dg = degree(g, mode="all")
#degree
clustering = transitivity(g, type="local",isolates = "zero")
names(clustering) = names(dg)
#clustering coeffieciency,加上元素索引
pr = page_rank(g, vids = V(g), directed = FALSE, damping = 0.85,
          personalized = NULL, weights = NULL)
pr = pr$vector
#pagerank
between = betweenness(g, v = V(g), directed = FALSE, weights = NULL,
                          nobigint = TRUE, normalized = FALSE)
#betweenness centrality，时间有点长

centrality = data.frame(Gene = V(g)$name,
                        Dergee = dg,
                        Clustering = clustering,
                        PageRank = pr,
                        Betweenness = between
                        )
colnames(centrality) = c("Gene ID","Degree","Clustering Coefficiency",
                         "PageRank","Betweenness")
outfile = paste(header,".parameter",sep="")
write.table(centrality,outfile,sep="\t",
            row.names=FALSE,quote =FALSE)
            #默认quote = TRUE，将字符串用引号括起来

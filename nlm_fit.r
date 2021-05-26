setwd("D:/liangyan123/分析代码/R画图/hlq")
library(ggplot2)

lib = read.table("lib3.txt",sep="\t",header=F)
colnames(lib) = c("Screens","PPIs","Std")

mmModel = nls(PPIs~Vm*Screens/(K+Screens),data=lib,start=list(Vm=30000, K=30))
summary(mmModel)

lib["Fitted"] = fitted(mmModel,c(1:10))


#查看拟合效果
#windowsFonts(Times=windowsFont("Times New Roman"))
p <- ggplot(lib,aes(x = Screens,y = PPIs))+
  geom_point(size=7,alpha = 0.5)+
  geom_errorbar(aes(ymin = PPIs-Std, ymax = PPIs+Std),
    width=0.3,size = 1.5)+ 
  geom_line(aes(x=Screens,y=Fitted),size = 1.5)+
  #scale_x_continuous(breaks = seq(1,11,1))+
  theme(plot.title = element_text(hjust = 0.5,size = 20, face = "bold"),
    axis.text=element_text(size = 15,face = "bold", vjust = 0.5, hjust = 0.5),
    axis.title = element_text(size = 15, face = "bold", vjust = 0.5, hjust = 0.5))+
  labs(x = "Number of Screens", y = "Cumulative number of PPIs")+ 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(), axis.line = element_line(colour = "black"))+
  theme(legend.title=element_blank())+ #去除图例的标题
  theme(legend.text = element_text(colour="BLACK", size = 15, face = "bold"))
  #theme(legend.position="none") #去除图例
p

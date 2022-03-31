#--- Load required packages
library("RedeR")
library("igraph")

#--- Set the R-to-Java interface
rdp <- RedPort()

#--- Initialize the R-to-Java interface
calld(rdp)

#--- Add a graph
g1 <- graph.lattice(c(1,4,6))
addGraph(rdp, g=g1, layout=layout_with_kk(g1))
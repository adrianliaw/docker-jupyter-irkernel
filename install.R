install.packages("devtools")

install.packages('RCurl')
library(devtools)
install_github('armstrtw/rzmq')
install_github("IRkernel/IRdisplay")
install_github("IRkernel/IRkernel")

IRkernel::installspec()

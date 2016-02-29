## Example plot for latex-knitr
## xtable is important for the latex table formatting
require(plot3D)
require(KernSmooth)
require(xtable) # For tables which can be inserted into latex docs with knitr

half.torus <- function(){
  ## 3D Plot of Half of a Torus
  par(mar = c(2, 2, 2, 2))
  par(mfrow = c(1, 1))
  R <- 3
  r <- 2
  x <- seq(0, 2*pi,length.out=50)
  y <- seq(0, pi,length.out=50)
  M <- mesh(x, y)
  alpha <- M$x
  beta <- M$y
  surf3D(x = (R + r*cos(alpha)) * cos(beta),
         y = (R + r*cos(alpha)) * sin(beta),
         z = r * sin(alpha),
         colkey=FALSE,
         bty="b2",
         main="Half of a Torus")
}

random.stuff <- function(){
  ## Make x and y global so the latex code can read them
  x <- rnorm(10,sd=5,mean=20)
  y <- 2.5*x - 1.0 + rnorm(10,sd=9,mean=0)
  plot(x,y,xlab="Independent",ylab="Dependent",main="Random Stuff")
  x1 <- runif(8,15,25)
  y1 <- 2.5*x1 - 1.0 + runif(8,-6,6)
  points(x1,y1,col=2,pch=3)
  x2 <- runif(8,15,25)
  y2 <- 2.5*x2 - 1.0 + runif(8,-6,6)
  points(x2,y2,col=4,pch=5)
}

brownian.motion <- function(){
  set.seed(1213)  # for reproducibility
  x <- cumsum(rnorm(100))
  mean(x)
  plot(x, type = 'l')
}

load.galaxy.data <- function(){
  ## Yay astronomy for fun... this takes a little while to load,
  ## so it should only happen once at the beginning of
  ## the latex doc, not in the plotting calls
  ## http://www.sr.bham.ac.uk/~ajrs/R/r-tutorials.html#NEDplot
  url <- "http://www.sr.bham.ac.uk/~ajrs"
  file <- "R/datasets/a85_extended_NEDsearch.txt"
  A <<- read.table(paste(url, file, sep="/"), sep="|", skip=20, header=TRUE)
  close(url(paste(url, file, sep="/")))     # close connection after use
  colnames(A)[c(2, 3, 4, 5)] <<- c("name", "ra", "dec", "type")
}

plot.galaxy.data <- function(){
  A <- subset(A, ra > 9.5 & ra < 11.5 & dec > -10.3 & dec < -8.5)
  plot(dec ~ ra, data=A, pch=".")
  
  G <- subset(A, type=="G")
  G <- subset(G, !is.na(Redshift) & Redshift < 0.2)
  G$cols <- as.character(ifelse(G$Redshift > 0.1, "red", "blue"))
  remap <- function(x) ( x - min(x) ) / max( x - min(x) )    # map x onto [0, 1]
  fun.col <- function(x) rgb(colorRamp(c("blue", "red"))(remap(x)), maxColorValue = 255)
  G$cols <- with(G, fun.col(Redshift) )
  est <- bkde2D(G[c("ra", "dec")], bandwidth=c(0.07, 0.07), gridsize=c(101, 101))
  with(est, contour(x1, x2, fhat, drawlabels=FALSE, add=TRUE))
}

get.align <- function(num){
  # return a character vector used in the align argument of the xtable command.
  # For tables where the first column is left-aligned and the rest are right-aligned,
  # e.g. posterior output tables, reference point tables. Most tables really.
  # num is the number of columns in the table
  align <- c("l","l")
  for(i in 1:(num-1)){
    align <- c(align, "r")
  }
  return(align)
}

make.xtable <- function(## seed is a vector of seeds to use for randomness
  seed,
  ## num.rows are the number of rows you want in the table
  num.rows = 20,
  ## Caption to use in an xtable
  xcaption = "default",
  ## xlabel is the reference label to use in an xtable
  xlabel = "default"
){
  ## This function allows you to make professional-looking tables in latex, by accessing the
  ## R data/output directly and avoiding having to type values into the latex document.
  ## If the values change for any reason, simply re-run the latex script to rebuild the
  ## document and the tables will be rebuilt.
  tab <- data.frame(x=1:num.rows)
  colnames <- "\\textbf{ID}"
  for(s in seed){
    ## Generate num.rows random numbers between 1 and 20 and add as a new column
    tab <- cbind(tab, runif(num.rows, 1, 20))
    ## The $ signs tell latex to render the name as a math expression
    colnames <- c(colnames, paste0("$R_{s=",s,"}$"))
  }
  ## Take mean of columns
  tab <- cbind(tab, apply(tab[,2:(length(seed)+1)], 1, mean))
  ## Two \\ are needed to escape latex control functions
  colnames <- c(colnames, "$\\overline{R}$")
  
  ## Take standard deviation of columns
  tab <- cbind(tab, apply(tab[,2:(length(seed)+1)], 1, sd))
  colnames <- c(colnames, "$\\sigma$")
  colnames(tab) <- colnames
  
  return(print(xtable(tab, caption=xcaption, label=xlabel, align=get.align(ncol(tab))),
               caption.placement = "top", include.rownames=FALSE, sanitize.text.function=function(x){x}))
}

x <- rnorm(1000,sd=5,mean=20)
y <- 2.5*x - 1.0 + rnorm(1000,sd=9,mean=0)

load.galaxy.data() ## Creates global data frame 'A'
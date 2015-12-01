Rscript -e "library(knitr);opts_chunk$set(dev='cairo_ps',fig.path='knitr-cache/', fig.dpi=96, fig.width=7.5, fig.height=4, echo=FALSE, results=FALSE, message=FALSE, warning=FALSE, results='hide', cache=TRUE, cache.path='knitr-cache/');knit('./example.Rnw')" 1> knitrOutput.log 2>&1

@latex -synctex=1 "example.tex" && bibtex "example" && latex "example.tex" && latex "example.tex" && dvips "example.dvi" && ps2pdf "example.ps"

Rscript -e "library(knitr);knit('./example.Rnw')" 1> knitrOutput.log 2>&1

(@latex -synctex=1 "example.tex" && bibtex "example" && latex "example.tex" && latex "example.tex" && dvips "example.dvi" && ps2pdf "example.ps") 1> latexOutput.log 2>&1

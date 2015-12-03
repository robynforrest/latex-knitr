____
# latex-knitr

latex-knitr is an example project to allow you to get started using R's knitr package with latex on MS Windows.

_____________________________________________________________


## Prerequisites
* MikTex for Windows
* R (version 3.22 "Fire Safety" or later)
* R Package 'knitr' and its dependencies.
* Other R packages used in the example: plot3D, KernSmooth, xtable
* To provide knitr code examples in the document, you need to install devtools and the knitliteral package. Open Rgui and type the following:

```R
  install.packages("devtools")
  devtools::install_github("thell/knitliteral")
```

---
## How to run the example and create example.pdf

- Using the command line, navigate to the doc subdirectory and run the buildtex.bat file

- To clean up the build, run the cleantex.bat file.

- To remove the cached figures, delete the knitr-cache/ directory and all its contents.

---

# ThermalSampleR

`ThermalSampleR` is an R package and R Shiny GUI application designed for assessing sample size requirements for researchers performing critical thermal limits (CTL) studies (e.g. calculating CTmin or CTmax metrics). Much research has been performed in recent years to improve the methodology used during CTL studies, however, we are not aware of any research into the sample size requirements for these studies. Our package allows users to perform sample size assessments for both single-species studies and multi-species comparisons, which will be discussed in detail below and illustrated with full use-cases. 

`ThermalSampleR` is a companion package to the pending publication (currently under review): 

Owen, C.A., Sutton, G.F., Martin, G.D., van Steenderen, C.J.M., and Coetzee, J.A. Sample size planning for critical thermal limits studies. 


## 1. Installation

**Via GitHub:**       
`devtools::install_github("CJMvS/ThermalSampleR")`

**R Shiny Application:**      

**Via GitHub:**      
`shiny::runUrl("https://github.com/CJMvS/ThermalSampleR_Shiny/archive/main.tar.gz")`   

**Shiny Apps platform:**    
https://clarkevansteenderen.shinyapps.io/ThermalSampleR_Shiny/    

## 2. Basic usage 

Once the package has been installed, you need to call the package into your current R session: 

```{r}
library(ThermalSampleR)
```

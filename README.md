
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ThermalSampleR

`ThermalSampleR` is an R package and R Shiny GUI application designed
for assessing sample size requirements for researchers performing
critical thermal limits (CTL) studies (e.g. calculating CTmin or CTmax
metrics). Much research has been performed in recent years to improve
the methodology used during CTL studies, however, we are not aware of
any research into the sample size requirements for these studies. Our
package allows users to perform sample size assessments for both
single-species studies and multi-species comparisons, which will be
discussed in detail below and illustrated with full use-cases.

`ThermalSampleR` is a companion package to the pending publication
(currently under review):

Owen, C.A., Sutton, G.F., Martin, G.D., van Steenderen, C.J.M., and
Coetzee, J.A. Sample size planning for critical thermal limits studies.

## 1. Installation

**Via GitHub:**  
`devtools::install_github("CJMvS/ThermalSampleR")`

Once the package has been installed, you need to call the package into
your current R session:

``` r
library(ThermalSampleR)
```

**R Shiny Application:**

**Via GitHub:**  
`shiny::runUrl("https://github.com/CJMvS/ThermalSampleR_Shiny/archive/main.tar.gz")`

**Shiny Apps platform:**  
<https://clarkevansteenderen.shinyapps.io/ThermalSampleR_Shiny/>

## 2. Loading your raw data

A full worked example will be outlined in the following sections. The
first step is to load in your raw critical thermal limits raw data.
Input files must be saved in .csv format, with two columns: one column
containing unique species names (indicated by the `Group` column below)
and another column containing the response variable, with each row
representing a single individual that has been tested (e.g. Critical
Thermal Limit temperature data) (indicated by the `CTL_min` column
below). For example:

| Group     | CTL\_min |
|-----------|:--------:|
| Species A |    5     |
| Species A |    6     |
| Species B |    4     |
| Species B |    3     |
| Species C |    4     |
| Species C |    6     |

Alternatively, `ThermalSampleR` comes with an example dataset, named
`coreid_data`. The following worked example will use this as input.

``` r
coreid = ThermalSampleR::coreid_data
head(coreid)
```

    ##                          col response
    ## 1 Catorhintha schaffneri_APM        5
    ## 2 Catorhintha schaffneri_APM        5
    ## 3 Catorhintha schaffneri_APM        5
    ## 4 Catorhintha schaffneri_APM        4
    ## 5 Catorhintha schaffneri_APM        4
    ## 6 Catorhintha schaffneri_APM        4

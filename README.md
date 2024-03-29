
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

van Steenderen, C.J.M., Sutton, G.F., Owen, C.A., Martin, G.D., and
Coetzee, J.A. Sample size planning for critical thermal limits studies.

## 1. Installation

**Via GitHub:**  

```{r}
devtools::install_github("clarkevansteenderen/ThermalSampleR")
```

Once the package has been installed, you need to call the package into
your current R session:

``` r
library(ThermalSampleR)
```

**R Shiny Application:**

**Via GitHub:**  

```{r}
shiny::runUrl("https://github.com/clarkevansteenderen/ThermalSampleR_Shiny/archive/main.tar.gz")
```

**Shiny Apps web server:** 

<https://clarkevansteenderen.shinyapps.io/ThermalSampleR_Shiny/>

## 2. Loading your raw data

A full worked example will be outlined in the following sections. The
first step is to load in your raw critical thermal limits data. Input
files must be saved in .csv format, with two columns: one column
containing unique species names (indicated by the `col` column below)
and another column containing the response variable, with each row
representing a single individual that has been tested (e.g. Critical
Thermal Limit temperature data) (indicated by the `response` column
below). For example, you can inspect the built-in example data
(`coried_data`) in `ThermalSampleR` to see how your data should be
structured:

``` r
head(ThermalSampleR::coreid_data)
```

    ##                          col response
    ## 1 Catorhintha schaffneri_APM        5
    ## 2 Catorhintha schaffneri_APM        5
    ## 3 Catorhintha schaffneri_APM        5
    ## 4 Catorhintha schaffneri_APM        4
    ## 5 Catorhintha schaffneri_APM        4
    ## 6 Catorhintha schaffneri_APM        4

## 3. Sample size assessments - Single taxon

The simplest application of `ThermalSampleR` is to evaluate whether a
study has used a sufficient sample size to estimate the critical thermal
limits for a single taxon. Below, we perform these calculations to
estimate sample sizes required to accurately estimate the CTmin of
adults of the a stem-wilting insect *Catorhintha schaffneri* (denoted by
`Catorintha schaffneri_APM` in our dataframe) (Muskett et al., 2020).

We use a bootstrap resampling procedure to estimate the width of the 95%
confidence interval of our CTmin estimate across a range of sample
sizes, which defaults to starting at n = 3 individuals tested, and which
can be extrapolated to sample sizes greater than the sample size of your
existing data by specifying a value to `n_max`.

``` r
# Set a seed to make the results reproducible, for illustrative purposes. 
set.seed(2012)

# Perform simulations 
bt_one = boot_one(
  # Which dataframe does the data come from? 
  data = coreid_data, 
  # Provide the column name containing the taxon ID
  groups_col = col, 
  # Provide the name of the taxon to be tested
  groups_which = "Catorhintha schaffneri_APM", 
  # Provide the name of the column containing the response variable (e.g CTmin data)
  response = response, 
  # Maximum sample sample to extrapolate to 
  n_max = 49, 
  # How many bootstrap resamples should be drawn? 
  iter = 299)
dplyr::glimpse(bt_one)
```

    ## Rows: 14,053
    ## Columns: 14
    ## Groups: col, sample_size [47]
    ## $ col             <chr> "Catorhintha schaffneri_APM", "Catorhintha schaffne...
    ## $ sample_size     <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, ...
    ## $ mean_low_ci     <dbl> 2.722432, 2.722432, 2.722432, 2.722432, 2.722432, 2...
    ## $ mean_upp_ci     <dbl> 6.949809, 6.949809, 6.949809, 6.949809, 6.949809, 6...
    ## $ mean_ct         <dbl> 4.83612, 4.83612, 4.83612, 4.83612, 4.83612, 4.8361...
    ## $ width_ci        <dbl> 4.227377, 4.227377, 4.227377, 4.227377, 4.227377, 4...
    ## $ sd_width        <dbl> 2.428405, 2.428405, 2.428405, 2.428405, 2.428405, 2...
    ## $ sd_width_lower  <dbl> 1.798973, 1.798973, 1.798973, 1.798973, 1.798973, 1...
    ## $ sd_width_upper  <dbl> 6.655782, 6.655782, 6.655782, 6.655782, 6.655782, 6...
    ## $ median_pop_val  <dbl> 4.918367, 4.918367, 4.918367, 4.918367, 4.918367, 4...
    ## $ prop_ci_contain <dbl> 0.8762542, 0.8762542, 0.8762542, 0.8762542, 0.87625...
    ## $ iter            <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, ...
    ## $ lower_ci        <dbl> 3.2324491, 0.8720836, 0.8720836, 5.0000000, 5.00000...
    ## $ upper_ci        <dbl> 6.100884, 8.461250, 8.461250, 5.000000, 5.000000, 6...

The variable containing the bootstrap resamples should then be passed to
the `plot_one_group` function to visualise the simulation results. A
number of optional parameters can be passed to the function to alter the
aesthetics of the graphs.

``` r
plot_one_group(
  # Variable containing the output from running `boot_one` function
  x = bt_one, 
  # Minimum sample size to plot
  n_min = 3, 
  # Actual size of your existing dataset 
  n_max = 15, 
  # Colour for your experimental data
  colour_exp = "forestgreen", 
  # Colour for the extrapolated predictions 
  colour_extrap = "orange", 
  # Position of the legend
  legend.position = "right", 
  # Change the degree of shading on the graph 
  alpha_val = 0.25)
```

<img src="https://github.com/clarkevansteenderen/ThermalSampleR/blob/main/Figs/boot_one.png" height = 350>

Inspecting panel (a), we visualise the precision of our CTmin estimate
for *Catorhintha schaffneri*, whereby precision is measured as the width
of a 95% confidence interval. For example, in the context of CTLs, a CI
width of 1 indicates that practitioners can be 95% confident that their
CTL estimate is within 1 degree Celsius of the true CTmin value. The
smaller the CI width, the greater the precision of the CTL estimate.

In this example, the precision of our CTmin estimate was high and is not
predicted to improve substantially by increasing sample size once
approximately n = 20 individuals are tested, as the 95% confidence
interval reaches a plateau at n = 20. The plateau is in the
extrapolation section of the graph indicating that more individuals
would need to be tested for the 95% confidence interval to become
approximately stable. However, at the existing sample size of n = 15,
the researchers could be relatively confident that the CTmin estimate
they have obtained is precise to within approximately 1.2 - 1.5 degrees
Celsius. Researchers will need to decide for themselves what an
acceptable degree of precision is for their own datasets.

Inspecting panel (b), we visualise the sampling distribution (i.e. the
range of plausible CTmin values) for the taxa under study. This
assessment can produce biased results at small sample sizes because the
population parameter (e.g. the taxon’s CTmin) is unknown and must
therefore be estimated from the experimental data. Panel B gives an
indication of parameter estimation accuracy by plotting the proportion
of bootstrap resamples across each sample size for which the 95% CI
included the estimated population parameter. An accurate parameter
estimate should produce CI’s that, on \~ 95% of occasions, contain the
estimated population parameter.

In this example, the accuracy of our CTmin estimate was high once n &gt;
10 individuals were tested. The proportion of 95% CI’s containing the
estimated population parameter approximated the expectation that 95% of
the CI’s for a given sample size should ideally contain the population
parameter once n = 10 were tested. As noted above, because our
population parameter for *Catorhintha schaffneri* was estimated from n =
15 individuals tested, our assessment of parameter accuracy may be bias,
and thus, should be interpreted with caution.

***Take-home message***: As long as the researchers were content with
obtaining a CTmin estimate for *Catorhintha schaffneri* with a precision
of approximately 1.2 - 1.5 degrees Celsius, the experiment could be
concluded at n = 15 individuals tested. Adding additional samples above
n = 15 would likely improve the precision of the CTmin estimate,
however, the gain in precision must be considered in light of the
logistics, costs and ethics of testing additional specimens.

## 4. Sample size assessments - Comparing two taxa

`ThermalSampleR` also allows the user to estimate sample size adequacy
for studies comparing the critical thermal limits across multiple groups
(e.g. different taxa, populations, treatments applied, sexes…). For
example, the built-in example data (`coried`) in `ThermalSampleR`
contains CTmin data for 30 adults and 30 nymphs of the twig-wilting bug
*Catorhintha schaffneri*. The bug was imported from Brazil into South
Africa, where it has been released as a biological control agent of an
invasive plant, *Pereskia aculeata* (Muskett et al., 2020). Researchers
may be interested in determining whether releasing adults or nymphs
would lead to better establishment rates in the field. As such, the
researchers could assess the CTmin of each life-stage, and use these
data to release the life-stage with the lower CTmin value, as they would
be assumed to better tolerate low temperatures.

We apply a similar workflow as per the ‘Single Taxon’ assessments above.
We use a bootstrap resampling procedure to estimate the width of the 95%
confidence interval of the difference in CTmin estimates between our two
groups of interest (*Catorhintha schaffneri* adults vs nymphs) across a
range of sample sizes, which defaults to starting at n = 3 individuals
tested, and which can be extrapolated to sample sizes greater than the
sample size of your existing data by specifying a value to `n_max`.

``` r
# Set a seed to make the results reproducible, for illustrative purposes. 
set.seed(2012)

# Perform simulations 
bt_two <- boot_two(
  # Which dataframe does the data come from? 
  data = coreid_data, 
  # Provide the column name containing the taxon ID
  groups_col = col, 
  # Provide the name of the column containing the response variable (e.g CTmin data)
  response = response, 
  # Provide the name of the first taxon to be compared
  group1 = "Catorhintha schaffneri_APM", 
  # Provide the name of the second taxon to be compared
  group2 = "Catorhintha schaffneri_NPM", 
  # Maximum sample sample to extrapolate to 
  n_max = 49, 
  # How many bootstrap resamples should be drawn? 
  iter = 299)
dplyr::glimpse(bt_two)
```

    ## Rows: 14,053
    ## Columns: 11
    ## Groups: sample_size [47]
    ## $ sample_size    <int> 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3...
    ## $ mean_low_ci    <dbl> -2.132398, -2.132398, -2.132398, -2.132398, -2.13239...
    ## $ mean_upp_ci    <dbl> 2.906088, 2.906088, 2.906088, 2.906088, 2.906088, 2....
    ## $ mean_diff      <dbl> 0.386845, 0.386845, 0.386845, 0.386845, 0.386845, 0....
    ## $ width_ci       <dbl> 5.038485, 5.038485, 5.038485, 5.038485, 5.038485, 5....
    ## $ sd_width       <dbl> 1.870982, 1.870982, 1.870982, 1.870982, 1.870982, 1....
    ## $ sd_width_lower <dbl> 3.167504, 3.167504, 3.167504, 3.167504, 3.167504, 3....
    ## $ sd_width_upper <dbl> 6.909467, 6.909467, 6.909467, 6.909467, 6.909467, 6....
    ## $ iter           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 1...
    ## $ lower_ci       <dbl> -1.18429674, -1.28432422, -1.28432422, -2.77644511, ...
    ## $ upper_ci       <dbl> 2.517630, 3.950991, 3.950991, 2.776445, 2.602981, 3....

The variable containing the bootstrap resamples should then be passed to
the `plot_two_group` function to visualise the simulation results. A
number of optional parameters can be passed to the function to alter the
aesthetics of the graphs.

``` r
plot_two_groups(
  # Variable containing the output from running `boot_two` function
  x = bt_two, 
  # Minimum sample size to plot
  n_min = 3, 
  # Actual size of your existing dataset 
  n_max = 30, 
  # Colour for your experimental data
  colour_exp = "blue", 
  # Colour for the extrapolated predictions 
  colour_extrap = "red", 
  # Position of the legend
  legend.position = "right", 
  # Change the degree of shading on the graph 
  alpha_val = 0.25)
```

<img src="https://github.com/clarkevansteenderen/ThermalSampleR/blob/main/Figs/boot_two.png" height = 350>

Panel (a) can be interpreted analogously to panel (a) produced during
the ‘Single Taxon’ assessments above. Here, we are visualising the
precision of our estimate for the difference in CTmin for *Catorhintha
schaffneri* adults vs nymphs across sample sizes. In this example, where
n = 30 individuals were tested for both adults and nymphs of
*Catorhintha schaffneri*, the precision of our estimated difference
between the groups was high and is not predicted to improve
substantially by increasing sample size as the 95% confidence interval
reached a plateau at approximately n = 25. At n = 30, the researchers
could be relatively confident that the difference in CTmin between
adults and nymphs was within approximately 1.5 degrees Celsius. Again,
the researchers will need to decide for themselves what an acceptable
degree of precision is for their own datasets.

In panel (b), we visualise the 95% confidence interval of the mean
difference in CTmin between adults and nymphs. At n = 30 individuals
tested, it appears that the CTmin of one group (*Catorhintha schaffneri*
adults) may be slightly higher than for nymphs. However, the 95% CI
overlaps 0, indicating that the CTmins of adults and nymphs are unlikely
to be significantly different. Moreover, limits of the 95% CI are
relatively stable, indicating that adding additional samples is unlikely
to change the results obtained.

***Take-home message***: As long as the researchers were content with
obtaining an estimate for the difference in CTmin between *Catorhintha
schaffneri* adults and nymphs with a precision of approximately 1
degrees Celsius, the experiment could be concluded at n = 30 individuals
tested. Adding additional samples above n = 30 would likely improve the
precision of estimate, however, the gain in precision must be considered
in light of the logistics, costs and ethics of testing additional
specimens.

## 5. Test of Total Equivalency

This function performs a Test of Total Equivalency, as developed by [Duffy et al. (2021)](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2435.13928), and incorporates it into the ThermalSampleR package.

Using the same coreid dataset, the function can be applied as follows:

``` r
tte = equiv_tost(
    # Which dataframe does the data come from? 
    data = coreid_data, 
    # Provide the column name containing the taxon ID
    groups_col = col, 
    # Provide the name of the taxon to be tested
    groups_which = "Catorhintha schaffneri_APM", 
    # Provide the name of the column containing the response variable (e.g CTmin data)
    response = response, 
    # Define the skewness parameters
    skews = c(1,10), 
    # Define the equivalence of subsets to full population CT estimate (unit = degree Celcius)
    equiv_margin = 1, 
    # Size of the population to sample (will test subsamples of size pop_n - x against pop_n for equivalence). Defaults to population size = 30
    pop_n = 30
)

# Inspect ouput 
tte
```

<img src="https://github.com/clarkevansteenderen/ThermalSampleR/blob/main/Figs/tote_graph_readme.png" height = 350 width = 850>

Inspecting both panels indicates that the researchers would have been able to obtain CT estimates (in terms of both the mean and variance) equivalent to within 1 degree Celsius of the estimates derived from the full datset (n = 30) if they had tested approximately 10 - 12 individuals, irrespective of the skewness in the underlying data. Hindsight is a great tool. 

The more important application of the TOTE approach is to iteratively assess sample sizes during the course of the experiment. For example, [Duffy et al. (2021)](https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/1365-2435.13928) recommend collecting some pilot data, and then assess the sample size requirements to estimate CT traits. For example, had we tested 6 insects in a pilot study and assessed the sample size requirements, we would obtain the graph below. 

<img src="https://github.com/clarkevansteenderen/ThermalSampleR/blob/main/Figs/tte_plot_6.png" height = 350 width = 850>

It is evident that testing 6 individuals was not sufficient to obtain a reliable estimate of the CT trait in this example. The researchers would then add additional samples to their study (e.g. add another 10 individuals), and then re-test the sample size requirements, repeating the process until the TOTE curves plateu. 

## Acknowledgments

The authors would like to thank Pippa Muskett (Rhodes University, South
Africa) for providing the example coreid data. Moreover, we would like to thank Grant Duffy (University of Otago, Dundedin, New Zealand) for granting us permission to use the source code for the Test of Total Equivalency function. 

## References

Duffy, G.A., Kuyucu, A.C., Hoskins, J.L., Hay, E.M., and Chown, S.L. (2021). Adequate sample sizes for improved accuracy of thermal trait estimates. Functional Ecology 35: 2647-2662. [PDF](https://besjournals.onlinelibrary.wiley.com/doi/10.1111/1365-2435.13928)

Muskett, P.C., Paterson, I.D., and Coetzee, J.A. (2020). Ground-truthing
climate-matching predictions in post-release evaluations. Biological
Control 144: 104217.
[PDF](https://www.sciencedirect.com/science/article/abs/pii/S1049964419304669)

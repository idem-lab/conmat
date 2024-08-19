---
title: 'conmat: generate synthetic contact matrices for a given age-stratified population'
authors:
- affiliation: 1
  name: Nicholas Tierney
  orcid: 0000-0003-1460-8722
- affiliation: 1,2
  name: Nick Golding
  orcid: 0000-0001-8916-5570
- affiliation: 1,3
  name: Aarathy Babu
  orcid: 
- affiliation: 4
  name: Michael Lydeamore
  orcid: 0000-0001-6515-827X
- affiliation: 1,3
  name: Chitra Saraswati
  orcid: 0000-0002-8159-0414
date: today
bibliography: references.bib
tags:
- epidemiology
- R
- infectious disease
affiliations:
- index: 1
  name: Telethon Kids Institute
- index: 2
  name: Curtin University
- index: 3
  name: 
- index: 4
  name: Monash University
execute: 
  echo: true
  cache: true
format: 
  pdf: 
    keep-md: true
    fig-height: 4
    fig-align: center
    fig-format: png
    dpi: 300
  html: 
    keep-md: true
    fig-height: 4
    fig-align: center
    fig-format: png
    dpi: 300
---


::: {.cell}

:::

::: {.cell}

:::




# Summary

Contact matrices describe the number of contacts between individuals, typically age groups. They are used to create models of infectious disease spread. `conmat` is an R package which generates synthetic contact matrices for arbitrary input demography, ready for use in infectious diseases modelling.

There are currently few options for a user to access synthetic contact matrices [@socialmixr; @prem2017]. Existing code to generate synthetic contact matrices from @prem2017 are not designed for replicability, and are restricted to only selected countries with no sub-national demographic estimates available.

The software exposes model fitting and prediction separately to the user. Users can fit a model based on a contact survey such as POLYMOD [@mossong2008], then predict from this model to their own demographic data. This means users can generate synthetic contact matrices for any region, with any contact survey.

We demonstrate a use-case for `conmat` by creating contact matrices for sub-national level (in this case, a state) in Australia. 

For users who do not wish to run the entire `conmat` pipeline, we have pre-generated synthetic contact matrices for 200 countries, based on a list of countries from the United Nations, using a model fit to the POLYMOD contact survey. These resulting synthetic contact matrices, and the associated code, can be found in the syncomat analysis pipeline ([GitHub](https://github.com/idem-lab/syncomat), [Zenodo](https://zenodo.org/records/11365943)).

# Statement of need

Infectious diseases like influenza and COVID19 spread via social contact. If we can understand patterns of contact - which people are more likely be in contact with each other - then we will be able to create models of how disease spreads. Epidemiologists and public policy makers can use these models to make decisions to keep a population safe and healthy.

Empirical estimates of social contact are provided by social contact surveys. These provide samples of the frequency and type of social contact across different settings (home, work, school, other). 

An prominent contact survey is the "POLYMOD" study by @mossong2008, which surveyed 8 European countries: Belgium, Germany, Finland, Great Britain, Italy, Luxembourg, The Netherlands, and Poland [@mossong2008]. 

These social contact surveys can be projected on to a given demographic structure to produce estimated daily contact rates between age groups. These are known as contact matrices or synthetic contact matrices. A widely used approach by @prem2021 [@prem2021] produced contact matrices for 177 countries at "urban" and "rural" levels for each country. 

However, there were major limitations with the methods in @prem2021. First, not all countries were included in their analyses. Second, the contact matrices only covered broad scale areas. This presents challenges for decision makers who are often working at a sub-national geographical scale. Third, the code provided by Prem et al., was not designed for replicability and easy modification with user-defined inputs.

The `conmat` package was developed to fill the specific need of creating contact matrices for arbitrary demographic structures. We developed the method primarily to output synthetic contact matrices. We also provided methods to create next generation matrices.

# Example

We will generate a contact matrix for Tasmania, a state in Australia, using a model fitted from the POLYMOD contact survey. We can get the age-stratified population data for Tasmania from the helper function `abs_age_state()`:




::: {.cell}

```{.r .cell-code}
tasmania <- abs_age_state("TAS")
head(tasmania)
```

::: {.cell-output .cell-output-stdout}

```
# A tibble: 6 x 4 (conmat_population)
 - age: lower.age.limit
 - population: population
   year state lower.age.limit population
  <dbl> <chr>           <dbl>      <dbl>
1  2020 TAS                 0      29267
2  2020 TAS                 5      31717
3  2020 TAS                10      33318
4  2020 TAS                15      31019
5  2020 TAS                20      31641
6  2020 TAS                25      34115
```


:::
:::




We can then generate a contact matrix for Tasmania using `extrapolate_polymod()`.




::: {.cell}

```{.r .cell-code}
tasmania_contact <- extrapolate_polymod(population = tasmania)
tasmania_contact
```

::: {.cell-output .cell-output-stderr}

```

```


:::

::: {.cell-output .cell-output-stderr}

```
-- Setting Prediction Matrices -------------------------------------------------
```


:::


::: {.cell-output .cell-output-stderr}

```
A list of matrices containing the model predicted contact rate between ages in
each setting.
```


:::


::: {.cell-output .cell-output-stderr}

```
There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
```


:::


::: {.cell-output .cell-output-stderr}

```
* home: a 16x16 <matrix>
```


:::

::: {.cell-output .cell-output-stderr}

```
* work: a 16x16 <matrix>
```


:::

::: {.cell-output .cell-output-stderr}

```
* school: a 16x16 <matrix>
```


:::

::: {.cell-output .cell-output-stderr}

```
* other: a 16x16 <matrix>
```


:::

::: {.cell-output .cell-output-stderr}

```
* all: a 16x16 <matrix>
```


:::

::: {.cell-output .cell-output-stderr}

```
i Access each <matrix> with `x$name`
```


:::

::: {.cell-output .cell-output-stderr}

```
i e.g., `x$home`
```


:::
:::




We can plot the resulting contact matrix for Tasmania with `autoplot`:




::: {.cell}

```{.r .cell-code}
autoplot(tasmania_contact)
```

::: {.cell-output-display}
![](paper_files/figure-pdf/autoplot-contacts-1.png){fig-pos='H'}
:::
:::




# Implementation

The overall approach of `conmat` has two parts:

1) Fit a model to predict individual contact rate, using an existing contact survey
2) Predict a synthetic contact matrix using age population data

## Model fitting

`conmat` was built to predict at four settings: work, school, home, and other. 
One model is fitted for each setting. 
Each model fitted is a Poisson generalised additive model (GAM) which predicts the count of contacts, with an offset for the log of participants. 
The model has six covariates to explain six key features of the relationship between ages, 
and two optional covariates for attendance at school or work.
The two optional covariates are included depending on which setting the model is fitted for.

Each cell in the resulting contact matrix, indexed ($i$, $j$), is the predicted number of people in age group $j$ that a single individual in age group $i$ will have contact with per day. The sum over all of the $j$ age groups for a particular age group $i$ is the predicted total number of contacts per day for each individual of age group $i$.

The six covariates are:

- $|i-j|$, 
- ${|i-j|}^{2}$, 
- $i + j$, 
- $i \times j$, 
- $\text{max}(i, j)$ and 
- $\text{min}(i, j)$.

These covariates capture typical features of inter-person contact, where individuals primarily interact with people of similar age (the diagonals of the matrix), and with grandparents and/or children (the so-called 'wings' of the matrix).The key features of the relationship between the age groups, represented by the six covariates, are displayed in \@ref(fig:partial-plots) for the home setting. The $|i-j|$ term gives the strong diagonal, modelling people generally living with similar age people, and the $\max(i,j)$ and $\min(i,j)$ terms give the intergenerational effect of parents and grandparents with children.




::: {.cell}

:::

::: {.cell}
::: {.cell-output-display}
![](paper_files/figure-pdf/unnamed-chunk-7-1.png)
:::
:::




Visualising the partial predictive plots for other settings (school, work and other), shows patterns that correspond with real-life situations are observed. A full visualisation pipeline is available at https://idem-lab.github.io/conmat/dev/articles/visualising-conmat.html

# Conclusions and future directions

The `conmat` software provides a flexible interface to generating synthetic contact matrices using population data and contact surveys. These contact matrices can then be used in infectious disease modelling and surveillance.

The main strength of `conmat` is its interface requiring only age population data to create a synthetic contact matrix. Current approaches provide only a selection of country level contact matrices. This software can predict to arbitrary demography, such as sub-national, or simulated populations. 

We provide a trained model of contact rate that is fit to the POLYMOD survey for ease of use. The software also has an interface to use other contact surveys, such as @comix. This is important as POLYMOD represents contact patterns in 8 countries in Europe, and contact patterns are known to differ across nations and cultures.

The covariates used by conmat were designed to represent the key features that are typically present in a contact matrix for different settings (work, school, home, other). Including other sources of information that may better describe these contact patterns, such as inter-generational mixing, or differences in school ages of a local demographic, may improve model performance. 

The interface to the model formula in conmat is fixed; users cannot change the covariates of the model. This means that if there is an unusual structure in their contact data it might not be accurately captured by conmat. It was a design decision that was made to focus on the key feature of conmat: using just age population data to predict a contact matrix. 

Public health decisions are often based on age specific information, which means the more accurate your age specific models are, the better those decisions are likely to be. This is the first piece of software that will provide appropriate contact matrices for a population, which means more accurate models of disease. 

This work was used as a key input into several models for COVID-19 transmission and control in Australia and contributed to decisions around vaccination policy [@DohertyModelling].

Some future directions for this software include:

* Demonstrate fitting a model to other contact surveys from sources such as the `socialmixr` R package [@socialmixr].
* Predict to any age brackets - such as monthly ages, for example, 1, 3, 6, month year old infants
* Fitting to multiple contact surveys simultaneously, e.g., POLYMOD and CoMix
* Add uncertainty to estimates
* Add methods for including household size distributions
* Include known household age distributions as offsets in the 'home' setting model, in place of the whole population distribution. 

Software is never finished, and the software in its current format has proven useful for infectious disease modelling. In time we hope it can become more widely used and be useful for more applications in epidemiology and public health. 

# References

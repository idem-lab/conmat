---
title: 'conmat: generate synthetic contact matrices for a given age population'
authors:
- affiliation: 1
  name: Nicholas Tierney
  orcid: 0000-0003-1460-8722
- affiliation: 1,2
  name: Nick Golding
  orcid: 
- affiliation: 1,3
  name: Aarathy Babu
  orcid: 
- affiliation: 4
  name: Michael Lydeamore
  orcid: 
- affiliation: 1,3
  name: Chitra Saraswati
  orcid: 
date: "03 May 2024"
output:
  html_document:
    keep_md: yes
  pdf_document: default
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
---



# Summary

Epidemiologists and public policy makers need to understand the spread of infectious diseases in a population. Knowing which groups are most vulnerable, and how disease spread will unfold facilitates public health decision-making. Diseases like influenza and coronavirus spread via human-to-human, "social contact".  If we can measure the amount of social contact, we can use this to understand how diseases spread.

We can measure social contact through social contact surveys, where people  describe the number and type of social contact they have. These surveys provide an empirical estimate of the number of social contacts from one age group to another, as well as the setting of contact. For example, we might learn from a contact survey that homes have higher contact with 25-50 year olds and with 0-15 year olds, whereas workplaces might have high contact within 25-60 year olds.

These surveys exist for a variety of countries, for example, @mossong2008 the "POLYMOD" study, covered 8 European countries: Belgium, Germany, Finland, Great Britain, Italy, Luxembourg, The Netherlands and Poland [@mossong2008]. However, what do we do when we want to look at contact rates in different countries that haven’t been measured? We can use this existing data to help us project to countries or places that do not have empirical survey data. These are called "synthetic contact matrices". A very popular approach by Prem et al projected from the POLYMOD study to 152 countries [@prem2017]. This which was later updated to include contact matrices for 177 countries at "urban" and "rural" levels for each country [@prem2021]. 

However not all countries were included in this list from @prem2021, and for some analyses these synthetic contact matrices were at a large area, such as "urban" or "rural" for a given country. One limitation of this is that the predictions were not provided at smaller grained regons. This might be important, if for example, a public health group needed to make predictions for specific areas. It was challenging to apply the methodology used by Prem et al, as while their analysis code was provided, it was not designed for reuse. 

The `conmat` package was created to fill a specific need for creating synthetic contact matrices for specific local government areas for Australia, for work commissioned by the Australian government. We created methods and software to facilitate the following:

- Input: age and population data, and Output: synthetic contact matrix
- Create next generation matrices (NGMs)
- Apply vaccination reduction to NGMs
- Use NGMs in disease modelling
- Provide tidy Australian survey data from the Australian Bureau of Statistics for use.

# Example

As an example, let us generate a contact matrix for a local area using POLYMOD data.

Suppose we want to get a contact matrix for a given region in Australia, let's say the city of Perth. We can get that from a helper function, `abs_age_lga`.


```r
library(conmat)
perth <- abs_age_lga("Perth (C)")
perth
```

```
#> # A tibble: 18 × 4 (conmat_population)
#>  - age: lower.age.limit
#>  - population: population
#>    lga       lower.age.limit  year population
#>    <chr>               <dbl> <dbl>      <dbl>
#>  1 Perth (C)               0  2020       1331
#>  2 Perth (C)               5  2020        834
#>  3 Perth (C)              10  2020        529
#>  4 Perth (C)              15  2020        794
#>  5 Perth (C)              20  2020       3615
#>  6 Perth (C)              25  2020       5324
#>  7 Perth (C)              30  2020       4667
#>  8 Perth (C)              35  2020       3110
#>  9 Perth (C)              40  2020       1650
#> 10 Perth (C)              45  2020       1445
#> 11 Perth (C)              50  2020       1299
#> 12 Perth (C)              55  2020       1344
#> 13 Perth (C)              60  2020       1359
#> 14 Perth (C)              65  2020       1145
#> 15 Perth (C)              70  2020       1004
#> 16 Perth (C)              75  2020        673
#> 17 Perth (C)              80  2020        481
#> 18 Perth (C)              85  2020        367
```

We can get a contact matrix made for `perth` using the `extrapolate_polymod` function:


```r
perth_contact <- extrapolate_polymod(population = perth)
perth_contact
```

```
#> 
```

```
#> ── Setting Prediction Matrices ─────────────────────────────────────────────────
```

```
#> A list of matrices containing the model predicted contact rate between ages in
#> each setting.
```

```
#> There are 16 age breaks, ranging 0-75+ years, with a regular 5 year interval
```

```
#> • home: a 16x16 <matrix>
```

```
#> • work: a 16x16 <matrix>
```

```
#> • school: a 16x16 <matrix>
```

```
#> • other: a 16x16 <matrix>
```

```
#> • all: a 16x16 <matrix>
```

```
#> ℹ Access each <matrix> with `x$name`
```

```
#> ℹ e.g., `x$home`
```

We can plot this with `autoplot`


```r
autoplot(perth_contact)
```

<img src="paper_files/figure-html/autoplot-contacts-1.png" width="95%" style="display: block; margin: auto;" />

# Implementation

Conmat was built to predict at four settings: work, school, home, and other. The model is built to predict four separate models, one for each setting.
The model is a poisson generalised additive model (gam), predicting the count of contacts, with an offset of the log of participants. There are six terms to explain six key features of the relationship between ages, and optional terms for attendance at school or work, depending on which setting the model is predicting to.

The six key features of the relationship are shown in the figure below


```r
# use DHARMA to show a partial dep plot of the six main terms
```

## Model interfaces

We provide multiple levels for the user to interact with for model fitting, further detail can be seen at: https://idem-lab.github.io/conmat/dev/

* `fit_single_contact_model()`
    * Using contact survey data to fit a GAM model, adding provided target population information to provide population size information. Recommended for when you want to fit to just a single setting, for which you might want to provide your own contact survey data.

* `predict_contacts()`

    * This takes a fitted model from `fit_single_contact_model`, and then predicts to a provided population

* `fit_setting_contacts()`
    * Fits the `fit_single_contact_model()` to each setting. Recommended for when you have multiple settings to fit. Returns a list of fitted models. 

* `predict_setting_contacts()`
    * Takes a list of fitted models from `fit_setting_contacts()` and predicts to a given population for each setting.

* `estimate_setting_contacts()`
    * A convenience function that fits multiple models, one for each setting. This means fitting `fit_setting_contacts()` and then `predict_setting_contacts()`. Recommended for when you have multiple settings to fit and want to predict to a given population as well.

* `extrapolate_polymod()`
    * Takes population information and projects pre-fit model from POLYMOD - used for speed when you know you want to take an already fit model from POLYMOD and just fit it to your provided population.

# Future Work

* Create a contact matrix using a custom contact survey from another source, such as the `socialmixr` R package.
* Predict to any age brackets - such as monthly ages, for example, 1, 3, 6, month year old infants
* Add ability to fit multiple contact surveys at once, e.g., POLYMOD and another dataset
* Add ability to include known household age distributions as offsets in the 'home' setting model, in place of the whole population distribution. So compute household age matrices (like age-structured contact matrices, but for household members instead of contacts) from POLYMOD data. If we compute a different one for each household size, in the POLYMOD data (probably estimated with another GAM, to make best use of the limited data) we might be able to extrapolate household age matrices to new countries based on the distribution of household sizes.
* Add methods for including household size distributions
* Add uncertainty to estimates
* Move Australian centric data into its own package
* Add documentation on specifying your own GAM model and using this workflow

# References

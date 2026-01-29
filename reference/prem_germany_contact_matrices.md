# Contact matrices as calculated by Prem. et al.

Contact matrices as calculated by Prem. et al. (2021) PLoS Computational
Biology. Updated to use the latest corrected matrices from their 2021
publication. DOI: 10.1371/journal.pcbi.1009098

## Usage

``` r
prem_germany_contact_matrices
```

## Format

A list with 5 elements:

- home:

  A 16x16 matrix containing the number of home contacts, by 5 year age
  group

- work:

  A 16x16 matrix containing the number of workplace contacts, by 5 year
  age group

- school:

  A 16x16 matrix containing the number of school contacts, by 5 year age
  group

- other:

  A 16x16 matrix containing the number of other contacts, by 5 year age
  group

- all:

  A 16x16 matrix containing the number of all contacts, by 5 year age
  group

All age groups are 5 year age bands, from 0 to 80.

## Source

<https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1009098>

<https://github.com/kieshaprem/synthetic-contact-matrices>

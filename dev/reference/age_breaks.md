# Extract age break attribute information

Extract age break attribute information

## Usage

``` r
age_breaks(x)

# S3 method for class 'conmat_age_matrix'
age_breaks(x)

# S3 method for class 'conmat_setting_prediction_matrix'
age_breaks(x)

# S3 method for class 'setting_data'
age_breaks(x)

# S3 method for class 'ngm_setting_matrix'
age_breaks(x)

# S3 method for class 'setting_vaccination_matrix'
age_breaks(x)

# S3 method for class 'numeric'
age_breaks(x)

# S3 method for class 'matrix'
age_breaks(x)

# S3 method for class 'array'
age_breaks(x)

# S3 method for class 'predicted_contacts'
age_breaks(x)

# S3 method for class 'transmission_probability_matrix'
age_breaks(x)

# S3 method for class 'setting_contact_model'
age_breaks(x)

# Default S3 method
age_breaks(x)
```

## Arguments

- x:

  an object containing age break information

## Value

age breaks character vector

## Methods (by class)

- `age_breaks(conmat_age_matrix)`: Get age break information

- `age_breaks(conmat_setting_prediction_matrix)`: Get age break
  information

- `age_breaks(setting_data)`: Get age break information

- `age_breaks(ngm_setting_matrix)`: Get age break information

- `age_breaks(setting_vaccination_matrix)`: Get age break information

- `age_breaks(numeric)`: Get age break information

- `age_breaks(matrix)`: Get age break information

- `age_breaks(array)`: Get age break information

- `age_breaks(predicted_contacts)`: Get age break information

- `age_breaks(transmission_probability_matrix)`: Get age break
  information

- `age_breaks(setting_contact_model)`: Get age break information

- `age_breaks(default)`: Get age break information

## Examples

``` r
age_breaks <- c(0, 5, 19, 15)
age_break_names <- c("[0,5)", "[5,10)", "[10, 15)")
age_mat <- matrix(
  runif(9),
  nrow = 3,
  ncol = 3,
  dimnames = list(
    age_break_names,
    age_break_names
  )
)

age_mat <- new_age_matrix(age_mat, age_breaks)

age_breaks(age_mat)
#> [1]  0  5 19 15
```

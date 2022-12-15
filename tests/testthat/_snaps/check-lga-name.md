# check_lga_name() errors when there's an incorrect name

    Code
      check_lga_name("Imaginary World")
    Condition
      Error in `check_lga_name()`:
      ! The LGA name provided does not match LGAs in Australia
      x The lga name 'Imaginary World' did not match (it probably needs 'Imaginary World (C)' or similar
      i See `abs_lga_lookup` for a list of all LGAs

# check_lga_name() errors when the name is ambiguous

    Code
      check_lga_name("Sydney")
    Condition
      Error in `check_lga_name()`:
      ! The LGA name provided does not match LGAs in Australia
      x The lga name 'Sydney' did not match (it probably needs 'Sydney (C)' or similar
      i See `abs_lga_lookup` for a list of all LGAs


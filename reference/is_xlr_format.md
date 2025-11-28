# Test if an object is a `xlr_format`

Test if an object is a `xlr_format`

## Usage

``` r
is_xlr_format(x)
```

## Arguments

- x:

  An object to test

## Value

a logical.

## Examples

``` r
# Test if an object is a xlr_format
is_xlr_format(1)
#> [1] FALSE
bf <- xlr_format(font_size = 14)
is_xlr_format(bf)
#> [1] TRUE
```

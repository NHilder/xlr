# Clothes opinions data

This is a fake data set used to show how to work with the xlr package.

## Usage

``` r
clothes_opinions
```

## Format

### `clothes_opinions`

A data frame with 1000 rows and 20 variables.

- weight:

  Fake survey weights

- group:

  A grouping variable

- gender:

  A character vector for gender

- gender2:

  A haven labelled vector for gender

- age:

  A continuous age variable

- age_group:

  A character vector for grouped age, generated from `age`

- Q1_1:

  The first column in a question block asking whether pants are good to
  wear. Likert scale.

- Q1_2:

  The second column in a question block asking whether shirts are good
  to wear. Likert scale.

- Q1_3:

  The third column in a question block asking whether shoes are good to
  wear. Likert scale.

- Q1_4:

  The forth column in a question block asking whether pants are good to
  wear. Likert scale. This column is intentionally has no label.

- Q2_1,2,3,4,5,6:

  Multiple response columns. Question asking what is your favourite
  colour to wear.

- Q3_1,2,3:

  Multiple response columns. Question asking what is your favourite
  jewellery to wear.

- Q3_other:

  The other column for question 3

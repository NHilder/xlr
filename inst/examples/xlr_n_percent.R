library(xlr)
# lets define a xlr_n_percent, which combines counts (N) and proportions (pct between 0-1)
#
# Create a variable to represent count 10 with 50%
x <- xlr_n_percent(n = 10L, pct = 0.5)
# This will print nicely
x
# Now we can increase the number of decimal places to display
# The decimal places must be a positive integer
x <- xlr_n_percent(n = 10L, pct = 0.5, dp = 3L)
x
# We can also define a vector of xlr_n_percents
y <- xlr_n_percent(n = c(10L, 20L, 30L), pct = c(0.1055, 0.3333333, 0.1234567), dp = 2)
y
# You can convert existing data to a xlr_n_percent using dplyr verbs
df <- data.frame(N = c(0L, 20L, 33L, 43L), pct = c(0, 0.2, 0.33, 0.43251))
df |>
  dplyr::mutate(col_np = xlr_n_percent(N, pct))
# You can also change the styling of a xlr_n_percent column, this is only relevant
# if you print it to `Excel` with write_xlsx
df |>
  dplyr::mutate(col_np = xlr_n_percent(N,
                                       pct,
                                       dp = 2,
                                       style = xlr_format_numeric(font_size = 8)))

# You can also convert it to a neat formatted character with as.character()
xlr_n_percent(n = c(10L, 20L, 30L), pct = c(0.1055, 0.3333333, 0.1234567),
              dp = 2) |>
  as.character()
# if you change the number of percentages it changes in the character
xlr_n_percent(n = c(10L, 20L, 30L), pct = c(0.1055, 0.3333333, 0.1234567),
              dp = 0) |>
  as.character()

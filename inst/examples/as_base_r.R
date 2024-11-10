library(xlr)

# We create a xlr objects
a <- xlr_numeric(1:100)
b <- xlr_percent(1:100/100)
tab <- xlr_table(mtcars,"a title","a footnote")

# now lets convert them back to their base types
as_base_r(a)
as_base_r(b)
as_base_r(tab)

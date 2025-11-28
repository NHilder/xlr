# xlr and dplyr

[`xlr_table()`](https://nhilder.github.io/xlr/reference/xlr_table.md) is
designed to work with dplyr verbs by default. This is so you `mutate`,
`summarise`, `arrange` etc. your data without losing your `xlr_table`
information. Particularly if you have used `build_table` first on your
data, which outputs data as a `xlr_table`.

The list of currently supported dplyrs verbs are: `arrange`, `distinct`,
`filter`, `mutate`, `relocate`, `rename`, `rename_with`, `rowwise`,
`select`, `slice`, `slice_head`, `slice_max`, `slice_min`,
`slice_sample`, `slice_tail`, `summarise`.

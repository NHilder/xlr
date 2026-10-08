# Moving xlr to S7: design note

Status: for discussion, no code changes yet. Written during the
`code-review` branch (October 2026), checked against S7 0.2.2, dplyr 1.2.1 and
vctrs on R 4.6.1.

## Why consider S7

xlr stores its metadata in attributes on S3 objects. S7 offers:

- typed properties with validators, checked whenever an object is created or
  a property is set, instead of the separate `validate_*()`/`type_abort()`
  calls we have now;
- `@` access (`tbl@title`) and `prop()`/`set_props()`;
- generics and methods defined in one system, with multiple dispatch.

S7 needs R >= 3.5 and only imports `utils`, so the dependency cost is small
(xlr needs R >= 4.1).

## Current design

| Class | What it is | Metadata |
|---|---|---|
| `xlr_format` | a list with a placeholder element | 14 attributes (font, border, alignment...) |
| `xlr_table` | a tibble subclass (`xlr_table/tbl/tbl_df/data.frame`) | title, footnote and four `xlr_format`s as attributes |
| `xlr_vector`, `xlr_numeric`, `xlr_integer`, `xlr_percent`, `xlr_n_percent` | vctrs vectors (`new_vctr()` / `new_rcrd()`) | `dp`, `scientific`, `style` (an `xlr_format`), `excel_format` |

The `xlr_table` attributes survive dplyr verbs because `dplyr_generic()`
(`R/xlr_table.R`) re-creates the table after each verb.

## Each class

### `xlr_format`: a good candidate

It's a plain record with no data frame or vctrs behaviour, so it maps cleanly
to an S7 class with one property per attribute. The current
`validate_xlr_format()` rules become property types and a validator. `==` and
`!=` become S7 methods, and `print()` a `print` method.

Points to check:

- Every attribute read becomes `x@font_size` and so on. They're in
  `R/xlr_format.R` (`print()` and `==`), `R/xlr_to_workbook.R`
  (`xlr_format_to_openxlsx_format()`, `get_border_styles()`,
  `create_column_widths()`) and `pillar_shaft.xlr_vector()` in
  `R/xlr_vector.R`.
- `xlr_format`s are stored as attributes of the vectors and tables, which is
  fine for an S7 object.
- The vectors compare formats in `vec_ptype2()` / `vec_arith()` with `!=`.

### `xlr_table`: not possible as an S7 subclass of data.frame today

An S7 class with `parent = class_data.frame` gets the class
`c("xlr_table_s7", "data.frame", "S7_object")`. vctrs (and so dplyr) rejects
this because `S7_object` comes after `data.frame`:

```
dplyr::filter(t, a > 1)
#> `x` must be a vector, not a <xlr_table_s7> object.
#> x Detected incompatible data frame structure ... the subclass
#>   <xlr_table_s7/S7_object> must come before <data.frame>, not after.
```

So until S7 or vctrs change this, `xlr_table` has to stay an S3 tibble
subclass. Options:

1. **Keep `xlr_table` as S3, store one S7 "table metadata" object** (title,
   footnote, the four formats) as a single attribute. That gives validated
   properties in one place, while dplyr still sees a normal tibble.
2. **Keep it fully S3** and rely on the exported getters/setters
   (`get_title()`, `set_title()`, etc. in `R/xlr_table_accessors.R`) for a
   stable interface.

### The vctrs vectors: keep as S3

These depend on vctrs' S3 double dispatch (`vec_ptype2.x.y`, `vec_cast.x.y`,
`vec_arith.x.y`), which is how vctrs types work. Moving them to S7 would mean
re-implementing that behaviour, with the same class ordering problem as above.
Their `style` attribute could hold an S7 `xlr_format` without changing the
vector classes.

## Migration path

1. **Keep the public API stable first.** The getters/setters added in this
   review, `update_theme()` and the constructors are the interface. Code
   outside the class definitions should use them (or the internal `pull_*()`
   helpers), not `attr()`, so that the storage can change later.
2. **Convert `xlr_format` to S7** behind the same constructor
   (`xlr_format()`, `xlr_format_numeric()`) and `is_xlr_format()`. Keep
   `attr()`-style access working for one release if users rely on it.
3. **Optionally** move the `xlr_table` metadata into one S7 object stored as an
   attribute (option 1 above).
4. Re-check S7/vctrs compatibility before considering `xlr_table` or the
   vectors as S7 classes.

## Relationship to replacing openxlsx

openxlsx is no longer maintained and will be replaced. Most of the code that
reads `xlr_format` attributes is the openxlsx style conversion
(`xlr_format_to_openxlsx_format()`, `get_border_styles()`,
`column_to_style()`), which will be rewritten for the new Excel package anyway.
Converting `xlr_format` to S7 at the same time would mean touching that code
once rather than twice.

## Open questions

- Do it together with the openxlsx replacement, or before or after it?
- Is the `xlr_table` metadata object (option 1) worth it, or are the
  getters/setters enough?
- Do any users read the attributes directly (`attr(x, "title")`,
  `attr(fmt, "font_size")`)? If so, how long should that keep working?
- Should `xlr_format` properties be readable with `@` as part of the public
  API, or only through functions?

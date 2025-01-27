# Implicit conversion works for two xlr_vectors

    Code
      c(xlr_vector("a"), xlr_vector("a", "test"))
    Condition
      Warning:
      Attribute `excel_format` does not match, taking the attributes from the left-hand side.
    Output
      <xlr_vector[2]>
      [1] a a

---

    Code
      c(xlr_vector("a"), xlr_vector("a", style = xlr_format(font_size = 12)))
    Condition
      Warning:
      Attribute `style` does not match, taking the attributes from the left-hand side.
    Output
      <xlr_vector[2]>
      [1] a a


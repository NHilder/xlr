# font_size error messages

    Code
      beta_format(font_size = 0)
    Condition
      Error in `beta_format()`:
      i In argument: `font_size`.
      ! `font_size` must be greater than or equal to 1, not 0.

---

    Code
      beta_format(font_size = 410)
    Condition
      Error in `beta_format()`:
      i In argument: `font_size`.
      ! `font_size` must be less than or equal to 409, not 410.

---

    Code
      beta_format(font_size = 2.6)
    Condition
      Error in `beta_format()`:
      i In argument: `font_size`.
      ! `font_size` must be multiple of 0.5, not 2.6.

# print.beta_format looks correct

    Code
      print(beta_format())
    Output
      -- Text styling:
      size: 11, colour: "black", font: "calibri", style:
      -- Text alignment:
      Horizontal: "left", Vertical: "top", Indent: 0, Rotation: 0, Wrap text: FALSE

---

    Code
      print(beta_format(border = "left"))
    Output
      -- Text styling:
      size: 11, colour: "black", font: "calibri", style:
      -- Border:
      Sides: "left", Colours: "black", Styles: "thin"
      -- Text alignment:
      Horizontal: "left", Vertical: "top", Indent: 0, Rotation: 0, Wrap text: FALSE

---

    Code
      print(beta_format(border = c("right", "left")))
    Output
      -- Text styling:
      size: 11, colour: "black", font: "calibri", style:
      -- Border:
      Sides: "right" and "left", Colours: "black", Styles: "thin"
      -- Text alignment:
      Horizontal: "left", Vertical: "top", Indent: 0, Rotation: 0, Wrap text: FALSE


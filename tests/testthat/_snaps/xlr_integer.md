# xlr_integer.format prints the way we want it

    Code
      xlr_integer(1:100)
    Output
      <xlr_integer[100]>
        [1] 1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18 
       [19] 19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36 
       [37] 37  38  39  40  41  42  43  44  45  46  47  48  49  50  51  52  53  54 
       [55] 55  56  57  58  59  60  61  62  63  64  65  66  67  68  69  70  71  72 
       [73] 73  74  75  76  77  78  79  80  81  82  83  84  85  86  87  88  89  90 
       [91] 91  92  93  94  95  96  97  98  99  100

---

    Code
      tibble::tibble(test = xlr_integer(0:99))
    Output
      # A tibble: 100 x 1
            test
         <x_int>
       1       0
       2       1
       3       2
       4       3
       5       4
       6       5
       7       6
       8       7
       9       8
      10       9
      # i 90 more rows

# vec_arith.xlr_integer.xlr_integer raises warning when things don't match

    Code
      xlr_integer(1) + xlr_integer(1, style = xlr_format())
    Condition
      Warning:
      Attributes ("style) do not match, taking the attributes from the left-hand side.
    Output
      <xlr_integer[1]>
      [1] 2

# xlr_integer casting throughs an error when you lose precision

    Code
      vec_cast(c(1.2, 4.2, 4.5), xlr_integer())
    Condition
      Error in `xlr_integer()`:
      ! Can't convert from `x` <double> to <integer> due to loss of precision.
      * Locations: 1, 2, 3


# xlr_table() prints correctly

    Code
      print(x_xlr)
    Output
      # A xlr_table: 100 x 4
           b_int   b_pct   b_dbl d_vctr  
         <x_int> <x_pct> <x_dbl> <x_vctr>
       1       1      1%    1.00 1       
       2       2      2%    2.00 2       
       3       3      3%    3.00 3       
       4       4      4%    4.00 4       
       5       5      5%    5.00 5       
       6       6      6%    6.00 6       
       7       7      7%    7.00 7       
       8       8      8%    8.00 8       
       9       9      9%    9.00 9       
      10      10     10%   10.00 10      
      # i 90 more rows

---

    Code
      print(xlr_table(x_xlr, title = "test"))
    Message
      
      -- test ------------------------------------------------------------------------
    Output
      # A xlr_table: 100 x 4
           b_int   b_pct   b_dbl d_vctr  
         <x_int> <x_pct> <x_dbl> <x_vctr>
       1       1      1%    1.00 1       
       2       2      2%    2.00 2       
       3       3      3%    3.00 3       
       4       4      4%    4.00 4       
       5       5      5%    5.00 5       
       6       6      6%    6.00 6       
       7       7      7%    7.00 7       
       8       8      8%    8.00 8       
       9       9      9%    9.00 9       
      10      10     10%   10.00 10      
      # i 90 more rows

---

    Code
      print(xlr_table(x_xlr, footnote = "test"))
    Output
      # A xlr_table: 100 x 4
           b_int   b_pct   b_dbl d_vctr  
         <x_int> <x_pct> <x_dbl> <x_vctr>
       1       1      1%    1.00 1       
       2       2      2%    2.00 2       
       3       3      3%    3.00 3       
       4       4      4%    4.00 4       
       5       5      5%    5.00 5       
       6       6      6%    6.00 6       
       7       7      7%    7.00 7       
       8       8      8%    8.00 8       
       9       9      9%    9.00 9       
      10      10     10%   10.00 10      
      # i 90 more rows
      test

---

    Code
      print(xlr_table(x_xlr, "test_title", "test_footnote"))
    Message
      
      -- test_title ------------------------------------------------------------------
    Output
      # A xlr_table: 100 x 4
           b_int   b_pct   b_dbl d_vctr  
         <x_int> <x_pct> <x_dbl> <x_vctr>
       1       1      1%    1.00 1       
       2       2      2%    2.00 2       
       3       3      3%    3.00 3       
       4       4      4%    4.00 4       
       5       5      5%    5.00 5       
       6       6      6%    6.00 6       
       7       7      7%    7.00 7       
       8       8      8%    8.00 8       
       9       9      9%    9.00 9       
      10      10     10%   10.00 10      
      # i 90 more rows
      test_footnote


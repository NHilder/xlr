# beta_table() prints correctly

    Code
      print(x_beta)
    Output
      # A beta_table: 100 x 4
           b_int b_pct   b_dbl d_vctr  
         <b_int> <pct> <b_dbl> <b_vctr>
       1       1    1%    1.00 1       
       2       2    2%    2.00 2       
       3       3    3%    3.00 3       
       4       4    4%    4.00 4       
       5       5    5%    5.00 5       
       6       6    6%    6.00 6       
       7       7    7%    7.00 7       
       8       8    8%    8.00 8       
       9       9    9%    9.00 9       
      10      10   10%   10.00 10      
      # i 90 more rows

---

    Code
      print(beta_table(x_beta, title = "test"))
    Message
      
      -- test ------------------------------------------------------------------------
    Output
      # A beta_table: 100 x 4
           b_int b_pct   b_dbl d_vctr  
         <b_int> <pct> <b_dbl> <b_vctr>
       1       1    1%    1.00 1       
       2       2    2%    2.00 2       
       3       3    3%    3.00 3       
       4       4    4%    4.00 4       
       5       5    5%    5.00 5       
       6       6    6%    6.00 6       
       7       7    7%    7.00 7       
       8       8    8%    8.00 8       
       9       9    9%    9.00 9       
      10      10   10%   10.00 10      
      # i 90 more rows

---

    Code
      print(beta_table(x_beta, footnote = "test"))
    Output
      # A beta_table: 100 x 4
           b_int b_pct   b_dbl d_vctr  
         <b_int> <pct> <b_dbl> <b_vctr>
       1       1    1%    1.00 1       
       2       2    2%    2.00 2       
       3       3    3%    3.00 3       
       4       4    4%    4.00 4       
       5       5    5%    5.00 5       
       6       6    6%    6.00 6       
       7       7    7%    7.00 7       
       8       8    8%    8.00 8       
       9       9    9%    9.00 9       
      10      10   10%   10.00 10      
      # i 90 more rows
      test

---

    Code
      print(beta_table(x_beta, "test_title", "test_footnote"))
    Message
      
      -- test_title ------------------------------------------------------------------
    Output
      # A beta_table: 100 x 4
           b_int b_pct   b_dbl d_vctr  
         <b_int> <pct> <b_dbl> <b_vctr>
       1       1    1%    1.00 1       
       2       2    2%    2.00 2       
       3       3    3%    3.00 3       
       4       4    4%    4.00 4       
       5       5    5%    5.00 5       
       6       6    6%    6.00 6       
       7       7    7%    7.00 7       
       8       8    8%    8.00 8       
       9       9    9%    9.00 9       
      10      10   10%   10.00 10      
      # i 90 more rows
      test_footnote

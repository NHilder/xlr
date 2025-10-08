# Strings longer than 50 are reduced, when needed to

    Code
      test
    Output
      # A xlr_table: 10 x 5
               a greater_10_1                   greater_10_2 greater_10_3 greater_10_4
         <x_num> <x_vctr>                       <x_vctr>     <x_vctr>     <x_vctr>    
       1    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       2    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       3    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       4    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       5    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       6    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       7    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       8    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
       9    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~
      10    1.00 aaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~ aaaaaaaaaaa~

# Strings are at a minimum 10 elements

    Code
      test
    Output
      # A xlr_table: 10 x 5
               a under_10 over_10                                under_10.1 over_10.1 
         <x_num> <x_vctr> <x_vctr>                               <x_vctr>   <x_vctr>  
       1    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       2    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       3    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       4    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       5    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       6    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       7    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       8    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
       9    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~
      10    1.00 aaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa~ aaaaaaaa   aaaaaaaaa~

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


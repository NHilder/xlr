

create_block_question_df <-function(){
  data.frame("group" = c(rep("a",5),rep("b",5)),
             "gender" = rep(c("m","f"),5),
             "gender2" = haven::labelled(rep(c(1,2),5),
                                         c("male" = 1,
                                           "female" = 2),
                                         "The sex of the participant"),
             "gender3" = haven::labelled(rep(c(1,2),5),
                                         c("male" = 1,
                                           "female" = 2),
                                         "The gender of the participant"),
             "age" = c(1,2,NA,3,1,2,1,2,NA,3),
             "weight" = c(.2,.2,.1,.1,.3,.3,.4,.4,.6,.6),
             # My group likert data
             "Q1_1" = haven::labelled(rep(c(1:5),2),
                                      c("Strongly Disagree" = 1,
                                        "Disagree" = 2,
                                        "Neutral" = 3,
                                        "Agree" = 4,
                                        "Strongly Agree" = 5),
                                      "Pants are good to wear"),
             "Q1_2" = haven::labelled(c(5:1,5:1),
                                      c("Strongly Disagree" = 1,
                                        "Disagree" = 2,
                                        "Neutral" = 3,
                                        "Agree" = 4,
                                        "Strongly Agree" = 5),
                                      "Shirts are good to wear"),
             "Q1_3" = haven::labelled(c(rep(1,5),rep(5,5)),
                                      c("Strongly Disagree" = 1,
                                        "Disagree" = 2,
                                        "Neutral" = 3,
                                        "Agree" = 4,
                                        "Strongly Agree" = 5),
                                      "Shoes are good to wear"),
             "Q1_4" = haven::labelled(c(rep(2,5),rep(4,5)),
                                      c("Strongly Disagree" = 1,
                                        "Disagree" = 2,
                                        "Neutral" = 3,
                                        "Agree" = 4,
                                        "Strongly Agree" = 5)))
}


create_multi_response_df <- function(){

  tibble(
    col_1 = c("a","a","b","b","c","c","c"),
    col_2 = haven::labelled(
      c(1,1,1,2,2,2,2),
      c(d = 1, e = 2),
      label = "What is your favourite letter?"
    ),
    weight = c(.2,.2,.1,.1,.3,.3,.4),
    enjoy_fruit_apple = haven::labelled(
      c(1, 1, NA, NA, 1, NA, NA),
      c(Apple = 1),
      label = "What fruits do you enjoy eating? Apple"
    ),
    enjoy_fruit_banana = haven::labelled(
      c(1, NA, 1, 1, 1, NA, NA),
      c(Banana = 1),
      label = "What fruits do you enjoy eating? Banana"
    ),
    enjoy_fruit_pear = haven::labelled(
      c(1, 1, 1, 1, NA, 1, NA),
      c(Pear = 1),
      label = "What fruits do you enjoy eating? Pear"
    ),
    enjoy_fruit_other = c("Fruit is evil", NA, "Durian", "Banana is a herb",
                          "Strawberry", NA, NA),
    enjoy_veg_potato = c("Potato", NA, "Potato", "Potato", "Potato", "Potato","Potato"),
    enjoy_veg_tomato = c("Tomato", NA, "Tomato", NA, "Tomato", "Tomato","Tomato"),
    enjoy_veg_carrot = c(NA, "Carrot", "Carrot", "Carrot", "Carrot", "Carrot", "Carrot"),
    enjoy_veg_other = c("Broccoli", "Sprouts", "Don't make friends with salad",
                        "Peas", NA, NA, NA),
    enjoy_food_savoury = c("Savoury", "Savoury", NA, NA, "Savoury", "Savoury", "Savoury"),
    enjoy_food_sweet = c("Sweet", "Sweet", "Sweet", "Sweet", NA, "Sweet", "Sweet"),
    enjoy_food_other = c("Fasting", NA, NA, "Chocolate", "I'm ketogenic",
                         "Protein shakes", "Protein shakes")
  )
}

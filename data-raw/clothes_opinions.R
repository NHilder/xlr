
#' Create example survey data
#'
#' @param N the number of rows in the example dataset
#'
create_example_survey_data <- function(N = 1000){

  set.seed(123456)

  gender_str <- gender_col <- sample(c(1,2,3),
                                     N,
                                     replace = TRUE,
                                     prob=c(0.5,0.49,0.1))
  gender_str[gender_col==1] <- "male"
  gender_str[gender_col==2] <- "female"
  gender_str[gender_col==3] <- "non-binary"

  age <- sample(c(18:65),
                N,
                replace = TRUE)
  age_group <-
    case_when(age >= 18 & age <= 30 ~ "18-30",
              age >= 31 & age <= 40 ~ "31-40",
              age >= 41 & age <= 50 ~ "41-50",
              age >= 51 & age <= 65 ~ "51-65")

  wt <- sample(10:2000,
               N,
               replace = TRUE)

  output_data <-
    data.frame(
      "weight" = wt,
      "group" = c(rep("a",N/2),rep("b",500)),
      "gender" = gender_str,
      "gender2" = labelled(gender_col,
                           c("male" = 1,
                             "female" = 2,
                             "non-binary" = 3),
                           "The gender of the participant"),
      "age" = age,
      "age_group" = age_group,
      # My group likert data
      "Q1_1" = labelled(sample(1:5,
                               N,
                               replace = TRUE),
                        c("Strongly Disagree" = 1,
                          "Disagree" = 2,
                          "Neutral" = 3,
                          "Agree" = 4,
                          "Strongly Agree" = 5),
                        "Pants are good to wear"),
      "Q1_2" = labelled(sample(1:5,
                               N,
                               replace = TRUE),
                        c("Strongly Disagree" = 1,
                          "Disagree" = 2,
                          "Neutral" = 3,
                          "Agree" = 4,
                          "Strongly Agree" = 5),
                        "Shirts are good to wear"),
      "Q1_3" = labelled(sample(1:5,
                               N,
                               replace = TRUE),
                        c("Strongly Disagree" = 1,
                          "Disagree" = 2,
                          "Neutral" = 3,
                          "Agree" = 4,
                          "Strongly Agree" = 5),
                        "Shoes are good to wear"),
      "Q1_4" = labelled(sample(1:5,
                               N,
                               replace = TRUE),
                        c("Strongly Disagree" = 1,
                          "Disagree" = 2,
                          "Neutral" = 3,
                          "Agree" = 4,
                          "Strongly Agree" = 5)),
      # Now lets define some multiple response function
      "Q2_1" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.2,0.8)),
                        c("Red" = 1),
                        "What is your favourite colour to wear?"),
      "Q2_2" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.8,0.2)),
                        c("Yellow" = 1),
                        "What is your favourite colour to wear?"),
      "Q2_3" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.7,0.3)),
                        c("Green" = 1),
                        "What is your favourite colour to wear?"),
      "Q2_4" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.8,0.2)),
                        c("Blue" = 1),
                        "What is your favourite colour to wear?"),
      "Q2_5" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.1,0.9)),
                        c("Black" = 1),
                        "What is your favourite colour to wear?"),
      "Q2_6" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.5,0.5)),
                        c("Grey" = 1),
                        "What is your favourite colour to wear?"),
      "Q3_1" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.2,0.8)),
                        c("Rings" = 1),
                        "What is your favourite types of jewellery to wear?"),
      "Q3_2" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.8,0.2)),
                        c("Necklaces" = 1),
                        "What is your favourite types of jewellery to wear?"),
      "Q3_3" = labelled(sample(c(NA,1),N,replace = TRUE,prob = c(0.7,0.3)),
                        c("Earrings" = 1),
                        "What is your favourite types of jewellery to wear?"),
      "Q3_other" = sample(c(NA,"Sunglasses","Watches","Cheese","This is some weird text","Samm","Sandwich"),
                          N,
                          replace = TRUE,
                          prob = c(0.90,0.05,0.04,0.0025,0.0025,0.0025,0.0025))

    ) |>
    tibble() |>
    # lets actually just convert the labelled data to a character for Q2
    mutate(across(starts_with("Q2"),
                  ~ haven::as_factor(.x) |>
                      as.character()))

  # Now lets add NA's with a 5% chance to a number of variables
  NA_cols_1 <- sample(1:N,size = 50)
  NA_cols_2 <- sample(1:N,size = 50)
  NA_cols_3 <- sample(1:N,size = 25)
  # now apply the NA's
  output_data[NA_cols_1,"group"] <- NA
  output_data[NA_cols_2,"age"] <- NA
  output_data[NA_cols_2,"age_group"] <- NA

  output_data[NA_cols_3,"Q1_3"] <- NA
  output_data[NA_cols_3,"Q1_4"] <- NA

  output_data
}


# This saves the data. Not run
clothes_opinions <- create_example_survey_data()
usethis::use_data(clothes_opinions, overwrite = TRUE)


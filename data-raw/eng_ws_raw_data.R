# cleans data-raw/eng_ws_raw_data.Rds and outputs as data-clean/animals_english.csv 
# eng_ws_raw_data.Rds obtained from https://github.com/langcog/wordbank-book/tree/master/data/psychometrics
# which is used in context of book https://langcog.github.io/wordbank-book/psychometrics.html

library(tidyverse)

# note this ends with .Rds but read_rds doesn't work with it so I think it's actually a .Rdata file
# my understanding is that Rds files should be on object that can be loaded (and assigned) with read_rds 
# see here for more https://stackoverflow.com/questions/21370132/r-data-formats-rdata-rda-rds-etc
load("data-raw/eng_ws_raw_data.Rds")

english_words <- 
  eng_ws %>% 
  select(child = data_id, produces = value, word = definition, sex, age) %>% 
  mutate(
    produces = ifelse(produces == "produces", 1, 0), 
    sex = as.character(sex),
    word = word %>% str_remove(" \\(animal\\)")
  )

english_words %>% 
  na.omit() %>% 
  group_by(word) %>% 
  filter(n() >= 10, mean(produces) > 0.01, mean(produces) < 0.99) %>% 
  ungroup() %>% 
  spread(word, produces) %>% 
  na.omit() %>% 
  write_csv("data-clean/english_words.csv")

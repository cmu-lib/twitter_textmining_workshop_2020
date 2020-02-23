# This is the starter code for our workshop. We will be live coding together during the workshop.

library(tidyverse)
library(lubridate)
library(tidytext)

raw_tweets <- read_csv("sampled_tweets.csv", col_types = "cTcc", locale = locale(tz = "US/Eastern")) 

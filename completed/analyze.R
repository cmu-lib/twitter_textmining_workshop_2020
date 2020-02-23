library(tidyverse)
library(lubridate)
library(tidytext)

raw_tweets <- read_csv("sampled_tweets.csv", col_types = "cTcc", locale = locale(tz = "US/Eastern")) 

tweets <- raw_tweets %>% 
  # Immediately make a copy of the data since we will later on wantto make modifications wihtout needing to read in the whole CSV again
  mutate(
    text = str_replace_all(text, pattern = "http\\S+", ""),
    hour = floor_date(time, "hour")
    )

# Visualize tweets over time
ggplot(tweets) +
  geom_histogram(aes(x = time))

# Use group by, summarize, arrange to count tweets-per-user
user_tweet_counts <- tweets %>% 
  group_by(user) %>% 
  summarize(tweet_count = n()) %>% 
  arrange(desc(tweet_count))

# Look at only the top 100 users
top_100_users <- user_tweet_counts %>% 
  slice(1:100)

# Tokenization - splitting by word
tweet_tokens <- unnest_tokens(tweets, "word", "text")

tweet_tokens

# Coutning tokens
token_counts <- tweet_tokens %>% 
  # A shortcut for collapsing a table into coutns
  count(word, name = "token_count") %>% 
  arrange(desc(token_count))

# Stopwords - all the kinds of words we might want to remove if we're looking for significant content words
?get_stopwords
english_stopwords <- get_stopwords("en")$word
spanish_stopwords <- get_stopwords("es")$word
custom_stopwords <- c("t.co", "https", "electionday", "vote", "election2016")
usernames <- str_to_lower(tweets$user) %>% unique()
all_stopwords <- c(english_stopwords, spanish_stopwords, custom_stopwords, usernames)

cleaned_tweets <- tweet_tokens %>% 
  mutate(stopword = word %in% all_stopwords) %>% 
  filter(stopword == FALSE) %>% 
  # A shortcut for adding a count on a long table (instead of group-mutate-ungroup)
  add_count(word, name = "token_count") %>% 
  filter(token_count > 50)

n_distinct(cleaned_tweets$word)

hourly_tokens <- cleaned_tweets %>% 
  count(hour, word, name = "tokens_per_hour") %>% 
  add_count(hour, name = "hourly_tokens")

hourly_tokens

token_comparison <- hourly_tokens %>% 
  filter(word %in% c("florida", "ohio", "virginia", "texas", "pennsylvania")) %>% 
  mutate(proportion = tokens_per_hour / hourly_tokens)

token_comparison

ggplot(token_comparison)  +
  geom_line(aes(x = hour, y = proportion, color = word))

# TF-IDF ----

user_tokens <- cleaned_tweets %>% 
  filter(user %in% top_100_users$user) %>% 
  count(user, word, name = "word_count")

user_tf_idf <- user_tokens %>% 
  bind_tf_idf(word, user, word_count)

top_20_user_terms <- user_tf_idf %>% 
  group_by(user) %>% 
  filter(row_number(desc(tf_idf)) <= 20) %>% 
  summarize(top_tokens = str_c(word, collapse = ", "))

# Sentiment Analysis ----

bing_sentiments <- cleaned_tweets %>% 
  left_join(get_sentiments("bing"), by = "word") %>% 
  mutate(sentiment_value = if_else(sentiment == "positive", true = 1, false = -1, missing = 0))

averaged_sentiments <- bing_sentiments %>% 
  group_by(id, time) %>% 
  summarize(tweet_sentiment = mean(sentiment_value))

ggplot(bing_sentiments) +
  geom_density(aes(x = time, color = sentiment))

loughran_sentiment <- cleaned_tweets %>% 
  inner_join(get_sentiments("loughran"), by = "word")

ggplot(loughran_sentiment, aes(x = time, fill = sentiment)) +
  geom_density(position = "fill") +
  scale_fill_brewer(palette = "Dark2")

nrc_sentiment <- cleaned_tweets %>% 
  inner_join(get_sentiments("nrc"), by = "word")

ggplot(nrc_sentiment, aes(x = time, fill = sentiment)) +
  geom_density()

afinn_sentiments <- cleaned_tweets %>% 
  left_join(get_sentiments("afinn"), by = "word") %>% 
  mutate(value = coalesce(value, 0))

afinn_averaged_sentiments <- afinn_sentiments %>% 
  group_by(id, time) %>% 
  summarize(tweet_sentiment = mean(value))

ggplot(afinn_averaged_sentiments, aes(x = time, y = tweet_sentiment)) +
  geom_smooth()

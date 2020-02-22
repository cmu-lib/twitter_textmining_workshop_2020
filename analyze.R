library(tidyverse)
library(lubridate)
library(tidytext)

raw_tweets <- read_csv("sampled_tweets.csv", col_types = "cTcc", locale = locale(tz = "US/Eastern")) 

tweets <- raw_tweets

no_url_tweets <- tweets %>% 
  mutate(text = str_replace_all(text, pattern = "http\\S+", ""))

tweets <- no_url_tweets

tweets %>% 
  sample_n(size = 200000) %>% 
  write_csv("sampled_tweets.csv")

sampled_tweets <- read_csv("sampled_tweets.csv", col_types = "cTcc", locale = locale(tz = "US/Eastern"))

tweets <- sampled_tweets

ggplot(tweets, aes(x = hour)) + 
  geom_bar()

user_tweet_counts <- tweets %>% 
  group_by(user) %>% 
  summarize(tweet_count = n()) %>% 
  arrange(desc(tweet_count))

tweet_tokens <- unnest_tokens(tweets, "word", "text") %>% 
  add_count(word)

tweet_tokens

english_stopwords <- get_stopwords("en")$word
spanish_stopwords <- get_stopwords("es")$word
custom_stopwords <- c("t.co", "https", "electionday", "vote", "election2016")
all_stopwords <- c(english_stopwords, spanish_stopwords, custom_stopwords)


cleaned_tweets <- tweet_tokens %>% 
  mutate(stopword = word %in% all_stopwords) %>% 
  filter(stopword == FALSE) %>% 
  filter(n > 500) %>% 
  mutate(username = word %in% str_to_lower(tweets$user)) %>% 
  filter(username == FALSE)

n_distinct(cleaned_tweets$word)

hourly_tokens <- cleaned_tweets %>% 
  group_by(hour, word) %>% 
  summarize(n = n())

hourly_tf_idf <- hourly_tokens %>% 
  bind_tf_idf(word, hour, n)

top_20_terms <- hourly_tf_idf %>% 
  group_by(hour) %>% 
  filter(row_number(desc(tf_idf)) <= 30) %>% 
  ungroup() %>% 
  arrange(hour, desc(tf_idf))


bing_sentiments <- unnested_tweets %>% 
  left_join(get_sentiments("bing"), by = "word") %>% 
  mutate(sentiment_value = if_else(sentiment == "positive", true = 1, false = -1, missing = 0))

averaged_sentiments <- bing_sentiments %>% 
  group_by(id, time) %>% 
  summarize(tweet_sentiment = mean(sentiment_value))

ggplot(bing_sentiments, aes(x = time, color = sentiment)) +
  geom_density()

ggplot(bing_sentiments, aes(x = time, y = sentiment_value)) +
  geom_smooth()

ggplot(averaged_sentiments, aes(x = time, y = tweet_sentiment)) +
  geom_smooth()

loughran_sentiment <- unnested_tweets %>% 
  inner_join(get_sentiments("loughran"), by = "word")

ggplot(loughran_sentiment, aes(x = time, fill = sentiment)) +
  geom_density(position = "fill") +
  scale_fill_brewer(palette = "Dark2")

nrc_sentiment <- unnested_tweets %>% 
  inner_join(get_sentiments("nrc"), by = "word")

ggplot(nrc_sentiment, aes(x = time, fill = sentiment)) +
  geom_density(position = "fill") +
  scale_fill_brewer(palette = "Dark1")

afinn_sentiments <- unnested_tweets %>% 
  left_join(get_sentiments("afinn"), by = "word") %>% 
  mutate(value = coalesce(value, 0))

afinn_averaged_sentiments <- afinn_sentiments %>% 
  group_by(id, time) %>% 
  summarize(tweet_sentiment = mean(value))

ggplot(afinn_averaged_sentiments, aes(x = time, y = tweet_sentiment)) +
  geom_smooth()

CMU Gerrymandering Series - Twitter Text Analysis with R
=========================

Scripts for an R workshop by Matthew Lincoln for Carnegie Mellon University (February 2020).

## TL;DR

Click this link: https://mybinder.org/v2/gh/cmu-lib/twitter_textmining_workshop_2020/master?urlpath=rstudio

## What we'll be doing

We are going to examine a sample of a little over 215,000 tweets from the 2016 "Election Day" Twitter dataset compiled by George Washington University Libraries:

- https://gwu-libraries.github.io/sfm-ui/posts/2016-11-30-election-dataset

Harvesting data from Twitter is a nuanced and invovled process, and we won't be covering it in this workshop. Instead, I will be providing a pre-processed sample of tweets so that we can get straight into text mining. However, if you would like to learn how to begin harvesting your own custom Twitter data set, I recommend _The Programming Historian_'s ["Beginner's Guide to Twitter Data"](https://programminghistorian.org/en/lessons/beginners-guide-to-twitter-data) that offers a tutorial.

The dataset `sampled_tweets.csv` contains a random sample of 215,224 tweets taken from the full GWUL "Election Day" dataset of over 2 million tweets. We will be looking at this small sample to make sure our code can run quickly during the workshop. After the workshop, if you would like to try the same code on all 2 million tweets, [I have made it temporary available here until March 10th](https://figshare.com/s/c8eec6fe7a1971fd49e6). I have also only pulled out selected fields:

- the tweet `id`
- `user` name
- `time` of the tweet
- tweet `text` 

Twitter's API output provides a lot more contextual information that may be useful for you, especially if you are interested in network analysis, but that is outside the context of this one workshop.

## Accessing R

You will need to bring your own laptop to participate in this workshop. You will have two options for how to access R, RStudio, and the code and data we're using:

### Easy but Slightly Limited: Use the free web-based RStudio via Binder

For the purposes of this workshop, we'll have a web interface version of RStudio available at:

https://mybinder.org/v2/gh/cmu-lib/twitter_textmining_workshop_2020/master?urlpath=rstudio

**Note: this can take a few minutes to open up the first time that you load it; if it goes for a very long time, you can try reloading your browser window.**

This will give you virtually the same interface as you would have if you had R and RStudio installed on your local laptop, and will come with all the packages, scripts, and data files you need. In the lower-right panel, click on the file named `workshop.R` to open the script that we'll be coding together during the workshop.

Note, this web service does have two drawbacks: 

1. Because we're sharing space on this server, it's not very powerful. We'll be working with relatively small datasets in this workshop - so the code will run, but it will not be particularly snappy. If you eventually want to do bigger data analysis on your own texts, you will need to install R on your own machine.

2. Binder's servers are temporary and read-only! As long as you are working in the browser window, you'll be able to edit and run code. However if you close the window, or go for more than 10 minutes without interacting with it, Binder will reclaim your space (remember, we're sharing when we use this!) and any changes you made will be discarded. You CAN download your customized code files by selecting the files you want to download from the "Files" tab in the lower right, and then clicking More... > Export... and it will download them to your laptop.

### Difficult but Powerful: Install R and R Studio yourself on your own laptop ahead of time

We definitely recommend doing this if you have the time, as you'll be able to more easily save your work from this workshop. But it's a bit more involved than clicking one link. To do this:

1. Install R: https://cran.r-project.org/

2. Install RStudio Desktop (the FREE open source version): https://www.rstudio.com/products/rstudio/download/

3. [Download the workshop code](https://github.com/cmu-lib/twitter_textmining_workshop_2020/archive/master.zip), unzip it, and then double-click on `election_tweetmining.Rproj` to launch the project inside RStudio.

4. Install the tidyverse and other R packages as listed in the `install.R` file in the base directory of the workshop code.

**We won't be spending any time during this workshop helping you to set this up!** There are a lot of resources online on "how to install r and rstudio for XXX operating system".
If you run in to any difficulty, or if this sounds like way too much to start out with on this workshop, that's why we have option 1 described above.

## Completed script

The full workshop code is in `completed/analyze.R`

## Futher Reading

### TF-IDF

Term-frequency-inverse-document-frequency: an heuristic for ranking words that show up disproportionately in one document compared to the rest of the corpus

- <https://programminghistorian.org/en/lessons/analyzing-documents-with-tfidf>

### Sentiment Analysis

Sentiment analysis _attempts_ to score texts based on a variet of sentiment/emotion scales, from positive-negative or using a dictionary of categories of sentiment. Take a look at these with a grain of salt; it is extremely difficult to intuit sentiment from a single word.

### Topic Modeling

Topic modeling, a common term for Latent Dirichlet Analysis, seeks to find latent clusters of terms that tend to appear in the same documents (hence earning the name "topic" modeling). Useful for getting a sense of general subjects covered by a corpus



### Corpus similarity / difference measures

### String distance

How different are short strings, like "Leonardo da Vinci" and "Leeonardo de Vinci"? A variety of string distance measures can help you quantify this, and find fuzzy matches for strings that vary by spelling or typos:

- 

### Text Reuse

The R package [textreuse]() offers a few efficient techniques for finding larger-scale text re-use (quoting entire sentences or paragraphs) across documents in large corpora.

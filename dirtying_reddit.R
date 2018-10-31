

require(tidyverse)
require(stringr)


load('reddit_xmas_2017.RData')

reddit_new = reddit %>%
    mutate(author = str_c('https://www.reddit.com/user/', author)) %>%
    mutate(body = str_c('Comment: ', str_replace_all(body, '\\n|\\r', ' '))) %>%
    mutate(created_utc = as.character(created_utc)) %>%
    mutate(row = row_number(), aarow = str_c('postid: ', row)) %>%
    filter(row <= 10000) %>%
    gather(key=var, value=val, author, body, created_utc, aarow) %>%
    arrange(row, var) %>% select(val)

head(reddit_new)

write.table(reddit_new, 'reddit_dirty.txt', col.names=FALSE, row.names=FALSE,
    quote=FALSE)



posts1 <- tibble(X1=read_lines("reddit_dirty.txt"))





require(tidyverse)
require(stringr)


dat_orig = read.csv('fangraphs_data.csv')


ALeast = c('Orioles', 'Red Sox', 'Yankees', 'Rays', 'Blue Jays')
ALcent = c('White Sox', 'Indians', 'Tigers', 'Royals', 'Twins')
ALwest = c('Astros', 'Angels', 'Athletics', 'Mariners', 'Rangers')

dat = dat_orig %>%
    filter(Team %in% c(ALeast, ALcent, ALwest)) %>%
    filter(PA > 0) %>%
    unite(BB_K, BB, SO, sep='/') %>%
    mutate(division = case_when(Team %in% ALeast ~ 'East',
                                Team %in% ALcent ~ 'Central',
                                Team %in% ALwest ~ 'West')) %>%
    mutate(Team = str_replace(Team, ' ', '_')) %>%
    arrange(division, Team, Name, Season) %>%
    select(year=Season, name=Name, team=Team, division,
           PA, HR, 'BBrate'=BB., BB_K, AVG, FB, playerid) %>%
    mutate(name=droplevels(name), team=as.factor(team))
head(dat)

write_csv(dat, 'mlb.csv')



# Clean up BBrate and separate BB_K into two variables

dat1 = dat %>% mutate(BBrate = as.numeric(str_replace(BBrate, ' %', ''))/100) %>%
    separate(BB_K, into = c("BB", "K"), sep="/", convert=TRUE)
head(dat1)


# Calculate average HRs per FB per year per team
# result should be a table of team by year, values are HR/FB rate
# keep division as a variable

dat2 = dat %>% group_by(division, team, year) %>% summarize(HR_FB=sum(HR)/sum(FB)) %>%
    spread(key=year, value=HR_FB) %>% mutate(increased = `2018` > `2015`)


# turn this back into a "long" dataset and plot it
# color by team, facet by division
dat2b = dat2 %>% gather(key=year, value=HR_FB, `2015`:`2018`)
ggplot(dat2b, aes(color=team, linetype=team, x=as.numeric(year), y=HR_FB)) +
    geom_line() +
    scale_linetype_manual(values=rep(1:5, 3)) +
    facet_wrap(~ division, nrow=3)



# Calculate total HRs and PAs per year per team
# rows are teams, 8 variables, PA_2015, PA_2016, ..., HR_2015, HR_2016, ...
# hint, will need to use gather, unite, and spread, in that order

dat3 = dat %>% group_by(team, year) %>% summarize(HR=sum(HR), PA=sum(PA)) %>%
    gather(key=variable, value=value, HR, PA) %>%
    unite(var_year, variable, year) %>%
    spread(key=var_year, value=value)


# For each player, 2017+2018 HRs - 2015+2016 HRs
# note: if a player-year isn't in the data, don't include that player in
# the final result
# hint: you may run into an issue with duplicate player names

dat4 = dat %>% select(year, name, HR, playerid) %>%
    unite(playerid, playerid, name) %>%
    spread(key=year, value=HR) %>%
    mutate(hr_diff = `2018` + `2017` - `2016` - `2015`) %>%
    arrange(-hr_diff)
head(dat4)

ggplot(dat4, aes(x=hr_diff)) + geom_histogram()



# Remove seasons with less than 200 PA
# Calculate change in average from the previous year for each player-year, AVG_diff
# If the previous season is not present, AVG_diff should be NA

dat5 = dat %>% filter(PA >= 200) %>%
    unite(playerid, playerid, name) %>%
    complete(playerid, year) %>%
    arrange(playerid, year) %>%
    group_by(playerid) %>%
    mutate(AVG_diff = AVG - lag(AVG),
           next_AVG_diff = lead(AVG) - AVG)

ggplot(dat5, aes(x=AVG, y=AVG_diff)) + geom_point()
ggplot(dat5, aes(x=AVG, y=next_AVG_diff)) + geom_point()



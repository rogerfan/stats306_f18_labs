

## Assignment and operations

x <- 4
x = 4    # I personally prefer this
y = 3.5
z = 'hello'

res = 3*x^2/y + 2


## Using functions

?rnorm     # Look up documentation
rnorm(5)
rnorm(5, mean=-3, sd=5)


## Vectors

c('a', 'b', 'c')

vec1 = c(1, 3, 5)
vec2 = c(vec1, 6, 7, c(8, 9))

vec2[2:4]
vec2[c(2, 4, 5)]

vec1 + 3
sqrt(vec1)
log(vec1)
vec1 / c(2, 3, 4)

length(vec1)
min(vec1)
mean(vec1)
sum(vec1)


## Logical operations

a = TRUE
b = c(TRUE, FALSE)
a
!a
!b

x = c(1, 3, 5)
y = c(2, 3, 4)
x == y
x != y
x > y
x >= y

(3>2) | (1 == 0)
(3>2) & (1 == 0)

c = c(TRUE, TRUE, FALSE)
d = c(TRUE, FALSE, FALSE)
c & d
c | d


## Data Frames
# Note that the book and therefore the class tends to use tibbles, which
# are very similar to dataframes and use most of the same rules and syntax

df = data.frame(var1=rep(c('a', 'b', 'c'), 2),
                var2=rep(c(TRUE, FALSE), each=3), var3=1:6)

df$var2
df$var1

df$var4 = df$var3 + 3
df$var5 = df$var3 %% 2 == 0


df$var1
df$var1_alt = factor(df$var1, levels=c('b', 'a', 'c'))
df$var1_alt

as.numeric(df$var1)
as.numeric(df$var1_alt)

df$var1_alt2 = as.character(df$var1)
df_var1
df_var1_alt2


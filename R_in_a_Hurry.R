# R in a Hurry
# - Data Science FunConference
# - Derren Barken
# - February 28, 2015

## Slide 19: Print the cars dataframe
## ----------------------------------------------------------------------
## - The cars dataframe is built in
## - It is part of the "datasets" package
## - Type "data()" to see all the built in data sets 

cars

## Slide 20: Print the top 6 rows of the cars dataset
## ----------------------------------------------------------------------

head(cars)

## Slide 23: Plot the cars dataset
## ----------------------------------------------------------------------

plot(cars)

## Slide 24: Make a simple model using cars
## ----------------------------------------------------------------------
## - lm stands for Linear Model
## - The notation Y ~ X means a model where X predicts Y
## - X is the input, Y is the output
## - abline is a function that takes an intercept and slope
##     and draws a line on a graph
## - abline also knows how to take a model object and obtain
##     the intercept and slope from that object

model = lm(dist ~ speed, data=cars)
model
abline(model)

## Slide 32: Loading data from a CSV file
## ----------------------------------------------------------------------
## - setwd = SET Working Directory
## - change the directory name to your own working directory

setwd("C:/Users/dbarken/Dropbox/home/r.workshop/star/star.final")
dat = read.csv('star_clean.csv')

## Slide 33: Examining the dat dataframe
## ----------------------------------------------------------------------
## - The View() function works in both RStdio and RGui
## - If you are in a different environment, with only a
##     command line, try "str(dat)" instead.

View(dat)

## Slide 39: Vectors
## ----------------------------------------------------------------------
## - Vectors are constructed using the c() function.
## - c stands for Combine (values into a vector)
## - Elements of a vector can be accessed using square brackets
## - The colon is used to generate a vector of numbers
##    (e.g. try typing "1:3" at the command line)
## - You can put a vector inside the square brackets!

grades = c('A', 'B', 'C', 'D', 'F')

grades[2]          # prints "B"

grades[1:2]        # prints "A" "B"

grades[c(4,4,1)]   # prints "D" "D" "A"

## Slide 40: Working with Vectors
## ----------------------------------------------------------------------
## - this introduces the names() function

grades = c('A', 'B', 'C', 'D', 'F')
grades        # prints "A" "B" "c" "D" "F"
grades[2]     # prints "B"
grades[1:2]   # prints "A" "B"

points = c(4,3,2,1,0)
points
points[5]
points['A']   # prints NA

names(points) = grades
points        # prints 4 3 2 1 0 (with A B C D F above)
points['A']   # prints 4 (with an A above it)

my_grades = c('A', 'A', 'B', 'B')
my_grades     # prints "A" "A" "B" "B"

my_points = points[my_grades]
my_points     # prints 4 4 3 3 (with A A B B above)

mean(my_points) # prints 3.5

## Slide 41: Data Frames
## ----------------------------------------------------------------------
## - The data.frame() function is used to construct small
## -   data frames.  It takes name=vector pairs, separated by commas

students = data.frame(
  name          = c("Ari", "Brett", "Cathy"),
  math_score    = c(100, 50, 80),
  english_score = c(100, 80, 90)
)

students

# Slide 42: Built in data frame "airquality"
## ----------------------------------------------------------------------
## - Elements of a data frame can also be accessed using square brackets

airquality[1:40,]

# Slide 43: Built in data frame "iris"
## ----------------------------------------------------------------------
## - Some columns are numbers, some are strings
iris[40:60,]

# Slide 44: Built in data frame "mtcars"
## ----------------------------------------------------------------------
## - Both columns and rows have names

mtcars

# Slide 45: Extracting a subset of a data frame
## ----------------------------------------------------------------------
## Variable names can include periods

my.cars = c('Mazda RX4', 'Toyota Corolla')
my.cols = c('mpg', 'cyl', 'hp')
mtcars[my.cars, my.cols]

# Slide 46: Selecting a column using $rowname
## ----------------------------------------------------------------------

mtcars

mtcars$mpg

mean(mtcars$mpg)

## Slide 47: TRUE/FALSE vectors
## ----------------------------------------------------------------------

index = mtcars$mpg > 25

index # prints a vector with 32 TRUE/FALSE values

car_names = rownames(mtcars) 

car_names # prints 32 car names

car_names[index] # prints 6 car names

high_mpg_cars = car_names[index]

mtcars[high_mpg_cars,] # prints rows for high mpg cars

mtcars[index, ]        # same as above

## Slide 49: Returning to STAR data
## ----------------------------------------------------------------------

setwd("C:/Users/dbarken/Dropbox/home/r.workshop/star/star.final")

dat = read.csv('star_clean.csv')

View(dat)

# Slide 50: Reshaping the data with tapply
## ----------------------------------------------------------------------
## - tapply() takes three arguments: 
##     1.  a vector with data to be summed (or averaged, etc)
##     2.  a data frame with grouping information (the test and grade)
##     3.  the function to apply (sum)

## Here is a version "broken down" into four lines (for clarity).

student_counts = dat$Students.Tested
grouping_cols = c('Test.Name', 'Grade')
grouping_dat = dat[, grouping_cols]
result = tapply(student_counts, grouping_dat, sum)

View(result)

## Here is the same thing in one line

result_2 = tapply(dat$Students.Tested, dat[,c('Test.Name', 'Grade')], sum)

View(result_2)

## Slide 53: Copy data frame to clipboard
## ----------------------------------------------------------------------

write.table(result, 'clipboard', sep="\t", col.names=NA, na="")

## Slide 57: English scores over time
## ----------------------------------------------------------------------

idx = dat$Test.Name == 'CST English-Language Arts'

dat_english = dat[idx,]

scores = dat_english$Mean.Scale.Score
grades = dat_english$Grade
english_over_time = tapply(scores, grades, mean)
  
View(english_over_time)

plot(english_over_time, type='b', xaxt='n', xlab='Grade', ylab='Score')
axis(1, at=1:10, labels=rownames(english_over_time))

## Slide 58: English scores over time, take 2
## ----------------------------------------------------------------------

idx = dat$Test.Name == 'CST English-Language Arts'
dat_english = dat[idx,]
grades = dat_english$Grade

scores  = dat_english$Mean.Scale.Score
weights = dat_english$Pct.Test.Grade
weighted_scores = scores * weights

english_over_time_2 = tapply(weighted_scores, grades, sum)
View(english_over_time_2)

plot(english_over_time_2, type='b', xaxt='n', xlab='Grade', ylab='Score')
axis(1, at=1:10, labels=rownames(english_over_time_2))

## Slide 59: County median income vs General Math scores, grade 7
## ----------------------------------------------------------------------

setwd("C:/Users/dbarken/Dropbox/home/r.workshop/star/star.final")

dat = read.csv('star_clean_wide.csv')

idx_math_7 = dat$Grade == 7 & dat$Test.Name == 'CST Mathematics'
dat_math_7 = dat[idx_math_7,]

plot(Mean.Scale.Score ~ median.family.income, data=dat_math_7)

## Slide 61: Number of students vs General Math scores, grade 7
## ----------------------------------------------------------------------

plot(Mean.Scale.Score ~ Students.Tested, data=dat_math_7, log='x')

size_order = order(dat_math_7$Students.Tested)
dat_math_7_sorted = dat_math_7[size_order,]
View(dat_math_7_sorted)

## Slide 62: Remove outlier, replot median income vs math scores, grade 7
## ----------------------------------------------------------------------

idx = dat_math_7$County.Name != 'Sierra'

table(idx)

dat_math_7_v2 = dat_math_7[idx,]

plot(Mean.Scale.Score ~ median.family.income, data=dat_math_7_v2)

## Slide 63: Correlation of median income vs math scores, grade 7
## ----------------------------------------------------------------------

cor(dat_math_7_v2$median.family.income, dat_math_7_v2$Mean.Scale.Score)

## Slide 64: Linear regression, median income vs math scores, grade 7
## ----------------------------------------------------------------------

model = lm(Mean.Scale.Score ~ median.family.income, data=dat_math_7_v2)
abline(model)

summary(model)

## Slide 65: Spending per pupil vs math scores, grade 7
## ----------------------------------------------------------------------

plot(Mean.Scale.Score ~ Spend.Per.ADA, data=dat_math_7)

## Slide 67: Take out outlier, replot
## ----------------------------------------------------------------------

plot(Mean.Scale.Score ~ Spend.Per.ADA, data=dat_math_7_v2)
     
## Slide 68: Correlation and linear regression, spending vs math grade 7
## ----------------------------------------------------------------------

cor(dat_math_7_v2$Spend.Per.ADA, dat_math_7_v2$Mean.Scale.Score)

model = lm(Mean.Scale.Score ~ Spend.Per.ADA, data=dat_math_7_v2)
abline(model)

summary(model)


## Slide 69: Combined model: spending and income vs math grade 7
## ----------------------------------------------------------------------

model = lm(Mean.Scale.Score ~ Spend.Per.ADA + median.family.income, data=dat_math_7_v2)
summary(model)

## Slide 70: Income and spending
## ----------------------------------------------------------------------

plot(Spend.Per.ADA ~ median.family.income, data=dat_math_7_v2)

cor(dat_math_7_v2$Spend.Per.ADA, dat_math_7_v2$median.family.income)


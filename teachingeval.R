# making a Likert plot

require(likert)
require(plyr)

# load the data
data <- read.csv("teachingeval.csv",
                na.string="")

# rename the response columns from "Q1" to the actual questions
data <- rename(data, c(
  Q1 = "In-class work in groups has improved my understanding of the material", 
  Q2 = "Collaborative work with fellow students has made the class more enjoyable", 
  Q3 = "Being able to watch screen casts ahead of time has helped me prepare for class", 
  Q4 = "Having lecture slides available electronically is helpful", 
  Q5 = "I learned best when I watched a screencast ahead of material covered in class", 
  Q6 = "I learned best when I simply followed lectures without a screencast before", 
  Q7 = "I learned best studying material on my own in the textbook", 
  Q8 = "This course made me more likely to take another logic course", 
  Q9 = "This course made me more likely to take another philosophy course"))

# the likert responses are in columns 5-13
responses <- data[c(5:13)]

# get the factors right: Strongly Disagree is low, Strongly Agree is high
mylevels <- c('Strongly Disagree', 'Disagree', 'Neutral', 'Agree', 'Strongly Agree')

for(i in seq_along(responses)) {
  responses[,i] <- factor(responses[,i], levels=mylevels)
}

# compute Likert stuff and put it in lresponses
lresponses <- likert(responses)

# now plot it
plot(lresponses,
     ordered=FALSE,
     group.order=names(responses),
     colors=c('darkred','darkorange','palegoldenrod','greenyellow','darkgreen')) + ggtitle("Teaching Evaluations")

# now let's plot it by major, we need to omit the lines with NA (no answer) in the Major column
data <- na.omit(data)
respmaj <- data[c(5:13)]
for(i in seq_along(respmaj)) {
  respmaj[,i] <- factor(respmaj[,i], levels=mylevels)
}

# compute the Likert stuff
lrespmaj  <- likert(respmaj,grouping=data$Major)

# plot result by major
plot(lrespmaj,
     colors=c('darkred','darkorange','palegoldenrod','greenyellow','darkgreen'), 
     include.histogram=TRUE)

# plot a density map
plot(lrespmaj,type='density') + scale_color_manual(values=c('darkred','darkorange','palegoldenrod','greenyellow','darkgreen','purple','darkblue')) + ggtitle("Teaching Evaluations by Major")



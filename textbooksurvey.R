# making a Likert plot

# load necessary packages

require(likert)
require(plyr)
library(reshape2)

# load the data
survey <- read.csv("textbooksurvey.csv",
                 na.string="",
                 stringsAsFactors=FALSE)

# make the single-answer questions into factors and name levels

# levels used for Q5
survey$Q5 <- factor(survey$Q5)
levels(survey$Q5) <- c(
  "Never",
  "Rarely",
  "Once every couple of months",
  "Once or twice a month",
  "Once a week",
  "Several times a week")

# levels used for Q6-Q10
frequency <- c('Never', '2', '3', '4', 'Always') 
for(i in 27:31) {
  survey[,i] <- factor(survey[,i])
  levels(survey[,i]) <- frequency
}

# levels used for Q11
quality <- c("Not well at all", "2", "3", "4", "Very well")
survey$Q11 <- factor(survey$Q11)
levels(survey$Q11) <- quality

# levels used for Q12-Q16, Q23
agreement <- c('Not at all', '2', '3', '4', 'Very much')
for(i in c(33:37, 44)) {
  survey[,i] <- factor(survey[,i])
  levels(survey[,i]) <- agreement
}

# levels used for Q17
engagement <- c("Very boring", "2", "3", "4", "Very engaging")
survey$Q17 <- factor(survey$Q17)
levels(survey$Q17) <- engagement

# levels used for Q18
clarity <- c("Not clear at all", "2", "3", "4", "Very clear")
survey$Q18 <- factor(survey$Q18)
levels(survey$Q18) <- clarity

# levels used for Q21
price <- c("0$", 
          "Under 20$", 
          "$Between 20 and 50$", 
          "Between 50 and 100$",
          "Between 100 and 150$",
          "More than 150$")
survey$Q21 <- factor(survey$Q21)
levels(survey$Q21) <- price

# levels used for Q22
influence <- c("No influence at all", "2", "3", "4", "A major factor")
survey$Q22 <- factor(survey$Q22)
levels(survey$Q22) <- influence

# alternatively, make levels in all quality questions (Q10-17, Q23Rev) the same

generic <- c("Very bad", "Bad", "Neutral", "Good", "Very Good")
for(i in c(27:39,45)) {
  survey[,i] <- factor(survey[,i])
  levels(survey[,i]) <- generic
}

# Rename questions
survey <- rename(survey, c(
  Q1R1 = "I have bought my own hardcopy of the textbook",
  Q1R2 = "I have bought my own electronic (eBook) version of the textbook",
  Q1R3 = "I have a hardcopy of the textbook, but did not buy it myself",
  Q1R4 = "I have an electronic version of the textbook, but did not buy it myself",
  Q1R5 = "I borrow a copy of the text when I need it",
  Q1R6 = "I use the text in the library",
  Q1R7 = "I do not have or use the text at all",
  Q2="02.	If you use the text in electronic form, what is your preferred reader software?",
  Q3R1="Underline or highlight text",
  Q3R2="Make notes in the text",
  Q3R3="Make notes separately, not in the text",
  Q3R4="Use bookmarks or flags to highlight places in the text",
  Q3R5="I don't use the text in hardcopy",
	Q4R1="Underline or highlight text",
  Q4R2="Make notes in the text",
  Q4R3="Make notes separately, not in the text",
  Q4R4="Use bookmarks or flags to highlight places in the text",
  Q4R5="Print portions of the text",
  Q4R6="I don't use the text in electronic fom",
  Q5="05.	How often do you consult the textbook?",
  Q6="06.	Do you read the text in preparation for lectures?",
  Q7="07.	Do you review the text right after the material was covered in lectures?",
  Q8="08.	Do you consult the text during lectures?",
  Q9="09.	Do you read the text in preparation for exams?",
  Q10="10. Do you consult the text when working on homework problems?",
  Q11="11. How well placed are the figures in relation to the material they discuss?",
  Q12="12. How much do figures and diagrams help you understand the text?",
  Q13 = "13. How well are examples used to explain the material?",
  Q14 = "14. How adequate is the number of exercises/problems?",
  Q15 = "15. Is the text well-organized?",
  Q16 = "16. Do the explanations provide enough detail?",
  Q17 = "17. How engaging/interesting is the writing?",
  Q18 = "18. How understandable/clear is the writing?",
  Q19 = "19. What do you like about the text?",
  Q20 = "20. What do you dislike about the text?",
  Q21 = "21. How much money would you be happy to spend on a textbook for this course?",
  Q22 = "22. How much did the cost of the textbook influence your decision to buy it?",
  Q23 = "23. Is the price of the textbook too high for the amount of learning support it provides?",
  Q23Rev = "23. Is the price of the textbook too high for the amount of learning support it provides?",
  Q24 = "24. What is your gender identity?",
  Q25 = "25. What is your current year in university?",
  Q27	="27. What final grade do you expect to receive in this course?"))

# Likert plots

# plot Q6-10, textbook use pattern questions
lUseByText <- likert(items=survey[,27:31,drop=FALSE],
                   grouping=survey$Text)

plot(lUseByText, 
  ordered=TRUE,
  group.order=c('SLC','BBJ','ForallX','Chellas','Goldfarb'),
  colors=c('darkred', 'darkorange', 'palegoldenrod','greenyellow','darkgreen')
  ) + 
  ggtitle("Textbook Use Patterns")

# plot Q11-17, textbook quality questions
lQualityByText <- likert(items=survey[,c(32:39,45),drop=FALSE],
  grouping=survey$Text)

plot(lQualityByText, 
  ordered=FALSE,
  group.order=c('SLC','BBJ','ForallX','Chellas','Goldfarb'),
  colors=c('darkred', 'darkorange', 'palegoldenrod','greenyellow','darkgreen')
  ) + 
  ggtitle("Textbook Quality")

# plot only Logic I texts
plot(lQualityByText, 
  ordered=FALSE,
  group.order=c('ForallX','Chellas','Goldfarb'),
  colors=c('darkred', 'darkorange', 'palegoldenrod','greenyellow','darkgreen')
  ) + 
  ggtitle("Textbook Quality")

# plot a single question, say Q17, with original factors

levels(survey[,38]) <- engagement

lQ17byText <- likert(items=survey[,38,drop=FALSE],
                    grouping=survey$Text)

plot(lQ17byText, 
     ordered=TRUE,
     group.order=c('SLC','BBJ','ForallX','Chellas','Goldfarb'),
     colors=c('darkred','darkorange', 'palegoldenrod','greenyellow','darkgreen')
  ) + 
  ggtitle("Textbook Engagement")

# uncentered bar charts for single answer questions

lQ5byText <- likert(items=survey[,26,drop=FALSE],
                    grouping=survey$Text)
plot(lQ5byText, 
     ordered=TRUE,
     centered= FALSE,
     group.order=c('SLC','BBJ','ForallX','Chellas','Goldfarb'),
     colors=c('darkred','darkorange', 'gold', 'palegoldenrod','greenyellow','darkgreen')
  ) + 
  ggtitle("Textbook Use Frequency")

# bar charts for multiple answer questions

# extract the responses for Text and Q1
Q1 <- survey[,c(6,7:13)]

# sum each column, group by Text
Q1 <- ddply(Q1,.(Text),numcolwise(sum))

# convert to long form
Q1 <- melt(Q1,id.var="Text")

# make the stacked bar chart
ggplot() + 
  geom_bar(
    aes(x=Text,fill=variable,y=value),
    data=Q1,
    stat="identity") + 
  coord_flip() +
  ggtitle("01. How do you access the textbook?") +
  theme(legend.position = "bottom",
        axis.title.x = element_blank()) +
  guides(fill=guide_legend(title=NULL,ncol=1))

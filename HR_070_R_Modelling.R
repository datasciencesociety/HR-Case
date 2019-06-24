modeling <- data.frame(read.csv(file="file path", header=TRUE))
companies <- data.frame(read.csv(file="file path", header=TRUE))

total <- merge(modeling ,companies,by="rec_id")

library(aod)
library(ggplot2)

mylogit12 <- glm(result.x ~ lg.salary + Native.check + position_type + Number.of.languages.spoken_bin.x  , data = total[total$employer_name == "comp12",], family = "binomial")

summary(mylogit12)

mylogit4 <- glm(result.x ~ Age.squared.x + Number.of.languages.spoken_bin.x +experience_new_cleanup.x , data = total[total$employer_name == "comp4",], family = "binomial")

summary(mylogit4)

mylogit22 <- glm(result.x ~ Position_Duration_TILE10 + lead + lang_1_grade + Number.of.languages.spoken_bin.x  , data = total[total$employer_name == "comp22",], family = "binomial")

summary(mylogit22)

mylogit18 <- glm(result.x ~ Age.squared.x + lang_1_grade.x + Number.of.languages.spoken_bin.x + experience_new_cleanup.x , data = total[total$employer_name == "comp4",], family = "binomial")

summary(mylogit22)
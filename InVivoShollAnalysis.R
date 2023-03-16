library(plyr)
library(stringr)
library(ggplot2)
library(reshape)
library(car)
library(agricolae)
library(xlsx)
library(lme4)
library(nlme)
require(multcomp)
library(ggplot2)


#Read in data
d <- read.xlsx('', 1) #enter path of file
d$Image <- make.unique(d$Image)


d2 <- melt(d, id.vars=c('Image', 'Condition', 'Age'))
d2$Condition <- factor(d2$Condition)
d2$variable <- gsub('X', '', d2$variable)
d2$variable <- as.numeric(d2$variable)

names(d2) <- c('Image', 'Condition', 'Age', 'Radius', 'Intersections')
d2$Age <- factor(d2$Age, levels = c('P7', 'P14', 'P21', 'P63'))

#loess smoothening
ggplot(d2, aes(x=Radius, y=Intersections, group=Condition, fill=Condition)) + 
  stat_smooth(col='black', method='loess', span=0.5) + ylab('# Intersections') + 
  xlab ('Distance from Soma (um)') + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold")) +
  facet_grid(~Age)


#error bars mean +/- SEM
ggplot(d2, aes(x=Radius, y=Intersections, color=Condition, group=Condition)) + 
  stat_summary(geom='line', fun=mean) +
  stat_summary(fun.data=mean_se, geom='pointrange') + ylab('# Intersections') + theme_minimal()  +
  facet_grid(~Age)


#####################################################################
############               STATISTICS                     ###########
#####################################################################

cond_test_corAR <- nlme::lme(
  Intersections ~  1 + Condition,
  data = d2,
  random = ~ 1 | Image / Radius ,
  correlation = corAR1()
)


summary(cond_test_corAR)
AOV <- anova(cond_test_corAR)
AOV

tukeys <- summary(glht(cond_test_corAR, linfct=mcp(Condition="Tukey")))
tukeysPH <- data.frame(as.character(row.names(tukeys$linfct)), tukeys$test$pvalues)


#determine N
for (i in unique(d2$Condition)){
  print(paste(i, nrow(d2[d2$Condition == i & d2$Radius == 5, ]), sep='='))
}

library(ggplot2)
library(car)
library(nlme)
require(multcomp)

#Read in data
d <- read.csv('sholl_InputData.csv') #enter path of file

#loess smoothening
ggplot(d, aes(x=Radius, y=Intersections, group=condition, fill=condition)) + 
  stat_smooth(col='black', method='loess') + ylab('# Intersections') + 
  xlab ('Distance from Soma (um)') + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))

#error bars mean +/- SEM
ggplot(d, aes(x=Radius, y=Intersections, color=condition, group=condition)) + 
  stat_summary(geom='line', fun=mean) +
  stat_summary(fun.data=mean_se, geom='pointrange') + ylab('# Intersections') + theme_minimal()


#####################################################################
############               STATISTICS                     ###########
#####################################################################

d$condition <- as.factor(d$condition)

cond_test_corAR <- nlme::lme(
  Intersections ~  1 + condition,
  data = d,
  random = ~ 1 | Image.Name / Radius ,
  correlation = corAR1()
)


summary(cond_test_corAR)
AOV <- anova(cond_test_corAR)
AOV

tukeys <- summary(glht(cond_test_corAR, linfct=mcp(condition="Tukey")))
tukeysPH <- data.frame(as.character(row.names(tukeys$linfct)), tukeys$test$pvalues)

write.csv(tukeysPH, 'tukeysPostHoc_pvalues.csv', quote=F, row.names=F)
write.csv(AOV, 'ANOVA_output.csv', quote=F)


#determine N
for (i in unique(d$condition)){
  print(paste(i, nrow(d[d$condition == i & d$Radius == 5, ]), sep='='))
}

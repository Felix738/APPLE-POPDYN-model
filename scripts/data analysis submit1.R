#load necessary packages
#install.packages("multcomp")
library(multcomp)
library(tidyr)
library(dplyr)
#load results500_combined --> this file contains results from three different modelling 
#scenarios
#make sure that raw data are always loaded before operating any code chunks
#results500_no_damage_submit <- results500_damage_cor1_wat
str(results500_no_damage_submit)
str(results500_damage)
str(results500_damage_learning_submit)
#filter data for final leaf number per run
#add n_year and week_year
year <- rep(104, 1560500)
results500_no_damage_submit$n_year <- floor(results500_no_damage_submit$`[step]`/year)
results500_no_damage_submit$n_year
results500_damage_submit$n_year <- floor(results500_damage_submit$`[step]`/year)
results500_damage_submit$n_year
results500_damage_learning_submit$n_year <- floor(results500_damage_learning_submit$`[step]`/year)
results500_damage_learning_submit$n_year
results500_no_damage_submit$week_year <- (results500_no_damage_submit$`[step]`%%year)/2
results500_no_damage_submit$week_year
results500_damage_submit$week_year <- (results500_damage_submit$`[step]`%%year)/2
results500_damage_submit$week_year
results500_damage_learning_submit$week_year <- (results500_damage_learning_submit$`[step]`%%year)/2
results500_damage_learning_submit$week_year

#filter for final leaves
results500_no_damage_submit_final_leaves <- subset(results500_no_damage_submit, n_year == 29)
str(results500_no_damage_submit_final_leaves)
head(results500_no_damage_submit_final_leaves)
results500_damage_submit_final_leaves <- subset(results500_damage_submit, n_year == 29)
str(results500_damage_final_leaves)
head(results500_damage_final_leaves)
results500_damage_learning_submit_final_leaves <- subset(results500_damage_learning_submit, n_year == 29)
str(results500_damage_learning_submit_final_leaves)
head(results500_damage_learning_submit_final_leaves)

#plot results
plot(results500_no_damage_submit_final_leaves$`count leaves`, col = "green", 
     xlab = "Index different model runs", 
     ylab = "Final leaf number per run", 
     ylim = c(150, 2800))
legend("top", c("no damage", "damage no learning", "damage learning"),
       col=c("green", "red", "blue"), title="Leaf mining options", horiz=TRUE, 
       pch=1, cex=0.65)
points(results500_damage_cor1_final_leaves$`count leaves`, col = "blue")
points(results500_damage_learning_cor1_final_leaves$`count leaves`, col = "red")
abline(h=mean(results500_no_damage_final_leaves$`count leaves`), col="green", lwd = 2)
abline(h=mean(results500_damage_cor1_final_leaves$`count leaves`), col="blue", lwd = 2)
abline(h=mean(results500_damage_learning_cor1_final_leaves$`count leaves`), col="red", lwd = 2)
mean(results500_no_damage_submit_final_leaves$`count leaves`)
median(results500_no_damage_submit_final_leaves$`count leaves`)
sd(results500_no_damage_submit_final_leaves$`count leaves`)
mean(results500_damage_submit_final_leaves$`count leaves`)
median(results500_damage_submit_final_leaves$`count leaves`)
sd(results500_damage_cor1_final_leaves$`count leaves`)
mean(results500_damage_learning_submit_final_leaves$`count leaves`)
median(results500_damage_learning_submit_final_leaves$`count leaves`)
sd(results500_damage_learning_cor1_final_leaves$`count leaves`)

#statistical significance test of different model scenarios
#add a treatment column
results500_no_damage_submit_final_leaves$treatment <- rep("no_damage", 52000)
results500_damage_submit_final_leaves$treatment <- rep("damage", 52000)
results500_damage_learning_submit_final_leaves$treatment <- rep("damage_learning", 52000)
#combine dataframes
#results500_damage_final_leaves <- subset(results500_damage_final_leaves, select = -c(`[(who) + (mined_area_per_leaf / 100)] of leaves`, mean_plant_vigor))
#results500_damage_learning_submit_final_leaves <- subset(results500_damage_learning_submit_final_leaves, select = -c(`[(who) + (mined_area_per_leaf / 100)] of leaves`, mean_plant_vigor))
#str(results500_no_damage_submit_final_leaves)
#str(results500_no_damage_submit_final_leaves)
combined_dat <- rbind(results500_no_damage_submit_final_leaves, results500_damage_submit_final_leaves, results500_damage_learning_submit_final_leaves)
#combined_dat <- rbind(results500_no_damage_submit_final_leaves, results500_damage_submit_final_leaves)
str(combined_dat)
#View(combined_dat)
boxplot(combined_dat$`count leaves`~combined_dat$treatment)
#check conditions for ANOVA for leaf number
combined_dat$treatment <- as.factor(combined_dat$treatment)
str(combined_dat)
lm1 <- lm(data = combined_dat, `count leaves`~treatment)
plot(resid(lm1))
hist(resid(lm1))
hist(combined_dat$`count leaves`)
#shapiro.test(combined_dat$`count leaves`)  --> sample size too big for shapiro wilk test
ANOVA1 <- aov(lm1)
summary(ANOVA1)
#post hoc test (Tukey)
glht<-glht(lm1,linfct=mcp(treatment="Tukey")) #Tukey Test
summary(glht) #result table with all comparisons
cld(glht) #Subgroup letters
label=c("damage_learning","damage_no_learning","no_damage")
boxplot(combined_dat$`count leaves`~combined_dat$treatment, 
        col=c("red","blue","green"), par(cex.axis=0.8), boxwex=.5, 
        xlab = "Model version", ylab = "Final leaf number", ylim=c(0,3000))
letters <- c("median = 683","median = 695","median = 721")
text(1:4, 2600, letters, cex=0.8)
letters <- c("a","b","c")
text(1:4, 2900, letters, cex=0.8)

#investigate fruit number per treatment
#to check data View(combined_dat[155950:156000,])
combined_dat$count_fruits <- (combined_dat$`count leaves`)/2 - (((combined_dat$`count leaves`)/2)/10)
#add a function of premature fruit drop in relation to leaf mining area
combined_dat[52000:156000,]$count_fruits <- (combined_dat[52000:156000,]$count_fruits) * (1 - (2.5 * (combined_dat[52000:156000,]$mean_mined_area_per_leaf/20))/100)

#check conditions for ANOVA for fruit number
combined_dat$treatment <- as.factor(combined_dat$treatment)
str(combined_dat)
lm1 <- lm(data = combined_dat, count_fruits~treatment)
plot(resid(lm1))
hist(resid(lm1))
hist(combined_dat$count_fruits)
ANOVA1 <- aov(lm1)
summary(ANOVA1)
#post hoc test (Tukey)
glht<-glht(lm1,linfct=mcp(treatment="Tukey")) #Tukey Test
summary(glht) #result table with all comparisons
cld(glht) #Subgroup letters
label=c("damage_learning","damage_no_learning","no_damage")
#boxplots of final fruit number per treatment
boxplot(combined_dat$count_fruits~combined_dat$treatment, par(cex.axis=0.8), 
        boxwex=.5, col=c("red","blue","green"), 
        xlab = "Model version", ylab = "Final fruit number", ylim=c(0,1400))
letters <- c("median = 307.4","median = 312.8","median = 324.5")
text(1:4, 1200, letters, cex=0.8)
letters <- c("a","b","c")
text(1:4, 1350, letters, cex=0.8)
median(combined_dat[1:51900,]$count_fruits)
sd(combined_dat[1:51900,]$count_fruits)
median(combined_dat[52000:104000,]$count_fruits)
sd(combined_dat[52000:104000,]$count_fruits)
median(combined_dat[104000:156000,]$count_fruits)
sd(combined_dat[104000:156000,]$count_fruits)

#plot leaf miner population against leaf number
#model scenario damage no learning
means_results500_leaves_damage_submit <- aggregate(results500_damage_submit$`count leaves`, list(results500_damage_submit$n_year), FUN=mean)
plot(means_results500_leaves_damage_submit)
means_results500_leaf_miners_damage_submit <- aggregate(results500_damage_submit$`count leaf_miners`, list(results500_damage_submit$n_year), FUN=mean)
plot(means_results500_leaf_miners_damage_submit)
#means_50_runs_leaves_damage$x <- means_50_runs_leaves_damage$x 
#means_50_runs_leaves_damage
#str(means_50_runs_leaves_damage)
#means_50_runs_leaf_miners_damage$`B_space50_damage$count.leaf_miners`

plot(means_results500_leaf_miners_damage_submit$x~means_results500_leaves_damage_submit$x, 
     xlab = "Mean leaf numbers of all model run", 
     ylab = "Mean leaf miner population all model runs", 
     main = "Damage")

#plot(means_50_runs_leaf_miners_damage$`B_space50_damage$count.leaf_miners`~means_50_runs_leaves_damage$x)
means_results500_leaves_learning_submit <- aggregate(results500_damage_learning_submit$`count leaves`, list(results500_damage_learning_submit$n_year), FUN=mean)
plot(means_results500_leaves_learning_submit)
means_results500_leaf_miners_learning_submit <- aggregate(results500_damage_learning_submit$`count leaf_miners`, list(results500_damage_learning_submit$n_year), FUN=mean)
plot(means_results500_leaf_miners_learning_submit)
plot(means_results500_leaf_miners_learning_submit$x~means_results500_leaves_learning_submit$x, 
     xlab = "Mean leaf numbers of all model runs", 
     ylab = "Mean leaf miner population all model runs", 
     main = "Damage learning")

#plot mean leaf miner population size against mean plant vigor and mean mined area against plant vigor 
#damage without learning
means_results500_plant_vigor_damage_cor1 <- aggregate(results500_damage_cor1$mean_plant_vigor, list(results500_no_damage$n_year), FUN=mean)
means_results500_mined_area_damage_cor1 <- aggregate(results500_damage_cor1$mean_mined_area_per_leaf, list(results500_no_damage$n_year), FUN=mean)
plot(means_results500_plant_vigor_damage_cor1)
plot(means_results500_mined_area_damage_cor1)
plot(means_results500_leaf_miners_damage_cor1$x~means_results500_plant_vigor_damage_cor1$x, 
     xlab = "Mean plant vigor of all model run", 
     ylab = "Mean lea miner population all model runs", 
     main = "Damage")
plot(means_results500_mined_area_damage_cor1$x~means_results500_plant_vigor_damage_cor1$x, 
     xlab = "Mean plant vigor of all model run", 
     ylab = "Mean lea miner population all model runs", 
     main = "Damage")
#no clear trend for both leaf miner population size and mined leaf area

#damage with learning
means_results500_plant_vigor_damage_learning_cor1 <- aggregate(results500_damage_learning_cor1$mean_plant_vigor, list(results500_no_damage$n_year), FUN=mean)
plot(means_results500_plant_vigor_damage_learning_cor1)
plot(means_results500_leaf_miners_learning_cor1$x~means_results500_plant_vigor_damage_learning_cor1$x, 
     xlab = "Mean plant vigor of all model run", 
     ylab = "Mean leaf miner population all model runs", 
     main = "Damage")

#logarithmic y axis
plot(means_results500_leaf_miners_damage_cor1$x~means_results500_leaves_damage_cor1$x, 
     xlab = "Mean leaf numbers of all model run", 
     ylab = "Mean leaf miner population all model runs", 
     main = "Damage",
     log = "y")
points(means_results500_leaf_miners_learning_cor1$x~means_results500_leaves_learning_cor1$x, log = "y")

#plots photosynthesis without and with damage
#plots leaf mining area
#results500_leaves_netphot_no_damage <- subset(results500_damage, mean_net_phot > 0)
#results500_leaves_netphot_damage <- subset(results500_damage, mean_net_phot_damage > 0)
#str(results500_leaves_netphot_no_damage)
#plot(results500_leaves_netphot_no_damage$mean_net_phot, col = "green", ylim=c(1.5, 4), xlim=c(0, 5700), cex=0.5)
#lines(results500_leaves_netphot_no_damage$mean_net_phot, col = "green", ylim=c(1.5, 4), xlim=c(0, 5700))
#points(results500_leaves_netphot_damage$mean_net_phot_damage, col = "red", cex=0.5)
#lines(results500_leaves_netphot_damage$mean_net_phot_damage, col = "red")
#plot(results500_leaves_netphot_damage$mean_mined_area_per_leaf)
#try different plotting options
results500_leaves_netphot_no_damage <- subset(results500_no_damage_submit, mean_net_phot > 0)
results500_leaves_netphot_damage <- subset(results500_damage_submit, mean_net_phot_damage > 0)
mean(results500_leaves_netphot_no_damage$mean_net_phot)
mean(results500_leaves_netphot_no_damage$mean_net_phot_damage)
mean(results500_damage_cor1$mean_net_phot)
mean(results500_damage_cor1$mean_net_phot_damage)
#plot(results500_damage$`random-seed`, xlim=c(0,3000))
#plot(results500_damage$`[step]`, xlim=c(0, 3000))
plot(results500_no_damage$mean_net_phot, col = "green", ylim=c(0, 4), xlim=c(0, 300), cex=0.5)
points(results500_damage_cor1$mean_net_phot_damage, col = "red", ylim=c(0, 4), xlim=c(0, 300), cex=0.5)
lines(results500_no_damage$mean_net_phot, col = "green", ylim=c(0, 4), xlim=c(0, 300), cex=0.5)
lines(results500_damage_cor1$mean_net_phot_damage, col = "red", ylim=c(0, 4), xlim=c(0, 300), cex=0.5)
#boxplot net assimilation with and without damage
#add a treatment colum
#also add the damage learning option
results500_leaves_netphot_damage_learning_submit <- subset(results500_damage_learning_submit, mean_net_phot_damage > 0)
results500_leaves_netphot_no_damage$treatment <- rep("no_damage", 675000)
results500_leaves_netphot_damage$treatment <- rep("damage", 645000)
results500_leaves_netphot_damage_learning_submit$treatment <- rep("damage_learning", 644899)
results500_leaves_netphot_damage_submit = subset(results500_leaves_netphot_damage, select = -c(mean_net_phot))
results500_leaves_netphot_no_damage_submit = subset(results500_leaves_netphot_no_damage, select = -c(mean_net_phot_damage))
results500_leaves_netphot_damage_learning_submit = subset(results500_leaves_netphot_damage_learning_submit, select = -c(mean_net_phot_damage))
colnames(results500_leaves_netphot_damage_submit)[colnames(results500_leaves_netphot_damage_submit) == "mean_net_phot_damage"] ="mean_net_phot"
colnames(results500_leaves_netphot_damage_learning_submit)[colnames(results500_leaves_netphot_damage_learning_submit) == "mean_net_phot_damage"] ="mean_net_phot"
#combine dataframes
combined_dat_phot_submit <- rbind(results500_leaves_netphot_no_damage_submit, results500_leaves_netphot_damage_submit, results500_leaves_netphot_damage_learning_submit)

#check conditions for ANOVA 
combined_dat_phot_submit$treatment <- as.factor(combined_dat_phot_submit$treatment)
str(combined_dat_phot_submit)
lm1 <- lm(data = combined_dat_phot_submit, mean_net_phot~treatment)
plot(resid(lm1))
hist(resid(lm1))
hist(combined_dat_phot_submit$mean_net_phot)
ANOVA1 <- aov(lm1)
summary(ANOVA1)
#post hoc test (Tukey)
glht<-glht(lm1,linfct=mcp(treatment="Tukey")) #Tukey Test
summary(glht) #result table with all comparisons
cld(glht) #Subgroup letters
#boxplots of final fruit number per treatment
boxplot(combined_dat_phot_submit$mean_net_phot~combined_dat_phot_submit$treatment, par(cex.axis=0.8), 
        col=c("red", "blue", "green"), boxwex=.5, 
        xlab = "Model version", ylab = expression("Mean net assimilation [µg m"^-2* "sec"^-1*"]"), ylim=c(0,7))
median(combined_dat_phot_submit[1:659954,]$mean_net_phot)
sd(combined_dat_phot_submit[1:659954,]$mean_net_phot)
median(combined_dat_phot_submit[659955:1319908,]$mean_net_phot)
sd(combined_dat_phot_submit[659955:1319908,]$mean_net_phot)
median(combined_dat_phot_submit[1319909:1964899,]$mean_net_phot)
sd(combined_dat_phot_submit[1319909:1964899,]$mean_net_phot)
letters <- c("median = 2.939", "median=3.16", "median = 3.195")
text(1:4, 6, letters, cex=0.8)
letters <- c("a","b","b")
text(1:4, 6.8, letters, cex=0.8)

#plot mean leaf water potential with and without damage
str(results500_damage_cor1$damage)

#plot mined area per leaf against its plant vigor with learning behavior
head(results500_damage_submit$`[(who) + (plant_vigor)] of leaves`)
str(results500_damage_submit$`[(who) + (plant_vigor)] of leaves`)
list_plant_vigor_submit <- subset(results500_damage_learning_submit, week_year == 36)
#list_plant_vigor_unnested <- list_plant_vigor %>% unnest(`[(who) + (plant_vigor)] of leaves`)
#list_plant_vigor$vigorlist <- unlist(list_plant_vigor$`[(who) + (plant_vigor)] of leaves`, recursive = TRUE, use.names = TRUE)
#process data for better readability
list_plant_vigor_submit$trial <- list_plant_vigor_submit$`[(who) + (plant_vigor)] of leaves`
list_plant_vigor_submit$trial_mine <- list_plant_vigor_submit$`[(who) + (mined_area_per_leaf / 100)] of leaves`
View(list_plant_vigor_submit[1,]$trial)
list_plant_vigor_submit[1:15000,]$trial <- gsub(" ", ",", list_plant_vigor_submit[1:15000,]$trial)
list_plant_vigor_submit[1:15000,]$trial_mine <- gsub(" ", ",", list_plant_vigor_submit[1:15000,]$trial_mine)
View(list_plant_vigor_submit[1,]$trial)
#write data into new object
write(list_plant_vigor_submit[1:15000,]$trial, file = "trial")
write(list_plant_vigor_submit[1:15000,]$trial_mine, file = "trial_mine")
#first trials to read in data in vector format for plant vigor
#trial <- read.delim("trial", sep = ",", dec=".")
#trial
trial1 <- scan("trial", what="", sep=",")
trial1
trial2 <- gsub("[[]", "", trial1)
trial2
trial3 <- gsub("[]]", "", trial2)
trial3
trial4 <- as.numeric(trial3)
trial4
trial5 <- as.vector(trial4)
trial5
#plot(trial5)
trial6 <- floor(trial5)
trial6
trial7 <- data.frame(trial5, trial6)
trial7
trial7$plant_vigor <- trial7$trial5 - trial7$trial6
trial7
trial8 <- trial7[2:3]
#trial8
hist(trial8$plant_vigor)
#first trials to read in data of mined area per leaf
trial1_mine <- scan("trial_mine", what="", sep=",")
trial1_mine
trial2_mine <- gsub("[[]", "", trial1_mine)
trial2_mine
trial3_mine <- gsub("[]]", "", trial2_mine)
trial3_mine
trial4_mine <- as.numeric(trial3_mine)
trial4_mine
trial5_mine <- as.vector(trial4_mine)
trial5_mine
#plot(trial5)
trial6_mine <- floor(trial5_mine)
trial6_mine
trial7_mine <- data.frame(trial5_mine, trial6_mine)
trial7_mine
trial7_mine$mined_area <- (trial7_mine$trial5_mine - trial7_mine$trial6_mine) * 100
trial7_mine
trial8_mine <- trial7_mine[2:3]
trial8_mine
#first plot mined area against plant vigor
plot(trial8_mine$mined_area~trial8$plant_vigor)
#linear model
lm_vigor_mine <- lm(trial8_mine$mined_area~trial8$plant_vigor)
summary(lm_vigor_mine)
#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)         2.52398    0.02498     101   <2e-16 ***
# trial8$plant_vigor 89.38656    0.08561    1044   <2e-16 ***
#Residual standard error: 25.11 on 3075775 degrees of freedom
#Multiple R-squared:  0.2617,	Adjusted R-squared:  0.2617 
#F-statistic: 1.09e+06 on 1 and 3075775 DF,  p-value: < 2.2e-16
x <- seq(0, 1, 0.01)
predict_vigor_mine <- 89.38656 * x + 2.52398
plot(trial8_mine$mined_area~trial8$plant_vigor, cex=0.4, 
     xlab="Plant vigor [leaves per sector/total leaves]", 
     ylab=expression("Damaged area [cm"^2*"]"), 
     cex.lab = 1.3, cex.axis = 1)
lines(predict_vigor_mine~x, col="green")
#try out same procedure without learning
list_plant_vigor_damage_submit <- subset(results500_damage_submit, week_year == 36)
list_plant_vigor_damage_submit$trial <- list_plant_vigor_damage_submit$`[(who) + (plant_vigor)] of leaves`
list_plant_vigor_damage_submit$trial_mine <- list_plant_vigor_damage_submit$`[(who) + (mined_area_per_leaf / 100)] of leaves`
View(list_plant_vigor[1,]$trial)
list_plant_vigor_damage_submit[1:15000,]$trial <- gsub(" ", ",", list_plant_vigor_damage_submit[1:15000,]$trial)
list_plant_vigor_damage_submit[1:15000,]$trial_mine <- gsub(" ", ",", list_plant_vigor_damage_submit[1:15000,]$trial_mine)
View(list_plant_vigor[1,]$trial)
#write data into new object
write(list_plant_vigor_damage_submit[1:15000,]$trial, file = "trial_damage")
write(list_plant_vigor_damage_submit[1:15000,]$trial_mine, file = "trial_mine_damage")
#first trials to read in data in vector format for plant vigor
#trial <- read.delim("trial", sep = ",", dec=".")
#trial
trial1_damage <- scan("trial_damage", what="", sep=",")
trial1_damage
trial2_damage <- gsub("[[]", "", trial1_damage)
trial2_damage
trial3_damage <- gsub("[]]", "", trial2_damage)
trial3_damage
trial4_damage <- as.numeric(trial3_damage)
trial4_damage
trial5_damage <- as.vector(trial4_damage)
trial5_damage
#plot(trial5)
trial6_damage <- floor(trial5_damage)
trial6_damage
trial7_damage <- data.frame(trial5_damage, trial6_damage)
trial7_damage
trial7_damage$plant_vigor <- trial7_damage$trial5_damage - trial7_damage$trial6_damage
trial7_damage
trial8_damage <- trial7_damage[2:3]
trial8_damage
#hist(trial8_damage$plant_vigor)
#first trials to read in data of mined area per leaf
trial1_mine_damage <- scan("trial_mine_damage", what="", sep=",")
trial1_mine_damage
trial2_mine_damage <- gsub("[[]", "", trial1_mine_damage)
trial2_mine_damage
trial3_mine_damage <- gsub("[]]", "", trial2_mine_damage)
trial3_mine_damage
trial4_mine_damage <- as.numeric(trial3_mine_damage)
trial4_mine_damage
trial5_mine_damage <- as.vector(trial4_mine_damage)
trial5_mine_damage
#plot(trial5)
trial6_mine_damage <- floor(trial5_mine_damage)
trial6_mine_damage
trial7_mine_damage <- data.frame(trial5_mine_damage, trial6_mine_damage)
trial7_mine_damage
trial7_mine_damage$mined_area_damage <- (trial7_mine_damage$trial5_mine_damage - trial7_mine_damage$trial6_mine_damage) * 100
trial7_mine_damage
trial8_mine_damage <- trial7_mine_damage[2:3]
trial8_mine_damage
#plot mined area against plant vigor for damage model option
plot(trial8_mine_damage$mined_area_damage~trial8_damage$plant_vigor)
#linear model
lm_vigor_mine_damage <- lm(trial8_mine_damage$mined_area~trial8_damage$plant_vigor)
summary(lm_vigor_mine_damage)
#Estimate Std. Error t value Pr(>|t|)    
#(Intercept)                8.27563    0.02871   288.3   <2e-16 ***
#trial8_damage$plant_vigor 80.40488    0.09844   816.8   <2e-16 ***
#Residual standard error: 28.73 on 3042046 degrees of freedom
#Multiple R-squared:  0.1799,	Adjusted R-squared:  0.1799 
#F-statistic: 6.672e+05 on 1 and 3042046 DF,  p-value: < 2.2e-16
x <- seq(0, 1, 0.01)
predict_vigor_mine_damage <- 80.40488 * x + 8.27563
plot(trial8_mine_damage$mined_area_damage~trial8_damage$plant_vigor, cex=0.4, 
     xlab="Plant vigor [leaves per sector/total leaves]", 
     ylab=expression("Damaged area [cm"^2*"]"), 
     cex.lab = 1.3, cex.axis = 1)
lines(predict_vigor_mine_damage~x, col="green")
#clear difference in between damage option and learning option in preference for 
#vigorous leaves
#with current procedure it is possible to read in all data of all leaves from nlrx output
#but there is no denotation of model step
#seems to me that linear model could be accepted --> but maybe nonlinear model more 
#accurate?

#plot mined area against leaf water potential per leaf
#read in data for leaf water potential
list_plant_vigor_damage <- subset(results500_damage_cor1, week_year == 36)
list_plant_vigor_damage$wat_pot <- list_plant_vigor_damage$`[(who) + (leaf_water_potential_damage / 2)] of leaves`
list_plant_vigor_damage$trial_mine <- list_plant_vigor_damage$`[(who) + (mined_area_per_leaf / 100)] of leaves`
#View(list_plant_vigor[1,]$trial)
list_plant_vigor_damage[1:15000,]$wat_pot <- gsub(" ", ",", list_plant_vigor_damage[1:15000,]$wat_pot)
list_plant_vigor_damage[1:15000,]$trial_mine <- gsub(" ", ",", list_plant_vigor_damage[1:15000,]$trial_mine)
#View(list_plant_vigor[1,]$trial)
#write data into new object
write(list_plant_vigor_damage[1:15000,]$wat_pot, file = "wat_pot_damage")
write(list_plant_vigor_damage[1:15000,]$trial_mine, file = "trial_mine_damage")
#first trials to read in data of leaf water potential per leaf
trial1_wat <- scan("wat_pot_damage", what="", sep=",")
trial1_wat
trial2_wat <- gsub("[[]", "", trial1_wat)
trial2_wat
trial3_wat <- gsub("[]]", "", trial2_wat)
trial3_wat
trial4_wat <- as.numeric(trial3_wat)
trial4_wat
trial5_wat <- as.vector(trial4_wat)
trial5_wat
#plot(trial5)
trial6_wat <- floor(trial5_wat)
trial6_wat
trial7_wat <- data.frame(trial5_wat, trial6_wat)
trial7_wat
trial7_wat$wat_pot <- (trial7_wat$trial5_wat - trial7_wat$trial6_wat) * 2
trial7_wat
trial8_wat <- trial7_wat[2:3]
trial8_wat
#plot mined area against plant vigor for damage model option
plot(trial8_wat$wat_pot~trial8_mine_damage$mined_area_damage, cex=0.4)
plot(trial8_mine_damage$mined_area_damage~trial8_wat$wat_pot, cex=0.4)
#linear model
lm_watpot_mine_damage <- lm(trial8_mine_damage$mined_area_damage~trial8_wat$wat_pot)
summary(lm_watpot_mine_damage)
x <- seq(0, 1, 0.01)
predict_vigor_mine_damage <- 61.93332 * x + 10.94524
plot(trial8_mine_damage$mined_area_damage~trial8_wat$wat_pot, cex=0.4, 
     xlab="Positive leaf water potential [HPa]", 
     ylab=expression("Mean damaged area [cm"^2*"]"))
lines(predict_vigor_mine_damage~x, col="green")
#no obvious relationship between leaf water potential and mined area per leaf
#possibly related to the fact that leaf temperature also plays a role?

#repetition of experiment recording leaf water potential limited by soil water potential
#only --> start with 50 repetitions
#filter data for final leaf number per run
#add n_year and week_year
str(results50_damage_cor1)
year <- rep(104, 156050)
results50_damage_cor1$n_year <- floor(results50_damage_cor1$`[step]`/year)
results50_damage_cor1$n_year
results50_damage_cor1$week_year <- (results50_damage_cor1$`[step]`%%year)/2
results50_damage_cor1$week_year
list50_soil_wat_damage <- subset(results50_damage_cor1, week_year == 36)
list50_soil_wat_damage$wat_pot <- list50_soil_wat_damage$`[(who) + (leaf_water_potential_soil_damage / 2)] of leaves`
list50_soil_wat_damage$trial_mine <- list50_soil_wat_damage$`[(who) + (mined_area_per_leaf / 100)] of leaves`
#View(list_plant_vigor[1,]$trial)
list50_soil_wat_damage[1:1500,]$wat_pot <- gsub(" ", ",", list50_soil_wat_damage[1:1500,]$wat_pot)
list50_soil_wat_damage[1:1500,]$trial_mine <- gsub(" ", ",", list50_soil_wat_damage[1:1500,]$trial_mine)
#View(list_plant_vigor[1,]$trial)
#write data into new object
write(list50_soil_wat_damage[1:1500,]$wat_pot, file = "soil_wat_pot_damage")
write(list50_soil_wat_damage[1:1500,]$trial_mine, file = "50_trial_mine_damage")
#first trials to read in data of leaf water potential per leaf
trial1_50wat <- scan("soil_wat_pot_damage", what="", sep=",")
trial1_50wat
trial2_50wat <- gsub("[[]", "", trial1_50wat)
trial2_50wat
trial3_50wat <- gsub("[]]", "", trial2_50wat)
trial3_50wat
trial4_50wat <- as.numeric(trial3_50wat)
trial4_50wat
trial5_50wat <- as.vector(trial4_50wat)
trial5_50wat
#plot(trial5)
trial6_50wat <- floor(trial5_50wat)
trial6_50wat
trial7_50wat <- data.frame(trial5_50wat, trial6_50wat)
trial7_50wat
trial7_50wat$wat_pot <- (trial7_50wat$trial5_50wat - trial7_50wat$trial6_50wat) * 2
trial7_50wat
trial8_50wat <- trial7_50wat[2:3]
trial8_50wat
#read in data of mined area per leaf 50 runs
trial1_50mine_damage <- scan("50_trial_mine_damage", what="", sep=",")
trial1_50mine_damage
trial2_50mine_damage <- gsub("[[]", "", trial1_50mine_damage)
trial2_50mine_damage
trial3_50mine_damage <- gsub("[]]", "", trial2_50mine_damage)
trial3_50mine_damage
trial4_50mine_damage <- as.numeric(trial3_50mine_damage)
trial4_50mine_damage
trial5_50mine_damage <- as.vector(trial4_50mine_damage)
trial5_50mine_damage
#plot(trial5)
trial6_50mine_damage <- floor(trial5_50mine_damage)
trial6_50mine_damage
trial7_50mine_damage <- data.frame(trial5_50mine_damage, trial6_50mine_damage)
trial7_50mine_damage
trial7_50mine_damage$mined_area_damage <- (trial7_50mine_damage$trial5_50mine_damage - trial7_50mine_damage$trial6_50mine_damage) * 100
trial7_50mine_damage
trial8_50mine_damage <- trial7_50mine_damage[2:3]
trial8_50mine_damage
#plot mined area against plant vigor for damage model option
plot(trial8_50wat$wat_pot~trial8_50mine_damage$mined_area_damage, cex=0.4, 
     xlab=expression("Mean damaged area [cm"^2*"]"), 
     ylab="Positive leaf water potential [HPa]")
plot(trial8_50mine_damage$mined_area_damage~trial8_50wat$wat_pot, cex=0.4)

#plot leaf water potential of damaged and undamaged leaves 50 model runs
#create dataframe for leaf water potential without damage
#add a treatment colum
treatment <- rep("no damage", 156050)
results_50_leaf_wat_no_damage <- data.frame(results50_damage_cor1$mean_leaf_wat_pot, treatment)
colnames(results_50_leaf_wat_no_damage)[colnames(results_50_leaf_wat_no_damage) == "results50_damage_cor1.mean_leaf_wat_pot"] ="wat_pot"
str(results_50_leaf_wat_no_damage)
#create dataframe for leaf water potential with damage
treatment <- rep("damage", 286862)
results_50_leaf_wat_damage <- data.frame(trial8_50wat$wat_pot, treatment)
colnames(results_50_leaf_wat_damage)[colnames(results_50_leaf_wat_damage) == "trial8_50wat.wat_pot"] ="wat_pot"
str(results_50_leaf_wat_damage)
combined_dat_wat <- rbind(results_50_leaf_wat_no_damage, results_50_leaf_wat_damage)
#plot damaged against undamaged leaf water potential
combined_dat_wat$treatment <- as.factor(combined_dat_wat$treatment)
boxplot(combined_dat_wat$wat_pot~combined_dat_wat$treatment)

#plot leaf water potential of damaged and undamaged leaves 500 model runs
#load raw data
results500_damage_cor1_wat <- readRDS("results500_damage_cor1_wat.rds")
#add week of the year
year <- rep(104, 1560500)
results500_damage_cor1_wat$week_year <- (results500_damage_cor1_wat$`[step]`%%year)/2
results500_damage_cor1_wat$week_year
#create a subset for the growing season
results500_damage_cor1_wat_growing <- subset(results500_damage_cor1_wat, week_year >= 16 & week_year <= 38)
results500_damage_cor1_wat_growing$week_year
results500_damage_cor1_wat_growing$mean_leaf_wat_pot_damage
#create separate dataframes for damaged and undamaged leaf water potential
#firstly for leaf water potential without damage
#add treatment columns
treatment <- (rep("no_damage", 675000))
leaf_wat_no_damage_500 <- data.frame(results500_damage_cor1_wat_growing$mean_leaf_wat_pot, treatment)
colnames(leaf_wat_no_damage_500)[colnames(leaf_wat_no_damage_500) == "results500_damage_cor1_wat_growing.mean_leaf_wat_pot"] ="wat_pot"
#secondly for leaf water potential with damage
treatment <- (rep("damage", 653482))
#remove unrealistic values --> many present in original dataset
leaf_wat_damage_500_sub <- subset(results500_damage_cor1_wat_growing, mean_leaf_wat_pot_damage >= 0.5 & mean_leaf_wat_pot_damage <= 1.28)
#str(leaf_wat_damage_500_sub)
leaf_wat_damage_500 <- data.frame(leaf_wat_damage_500_sub$mean_leaf_wat_pot_damage, treatment)
colnames(leaf_wat_damage_500)[colnames(leaf_wat_damage_500) == "leaf_wat_damage_500_sub.mean_leaf_wat_pot_damage"] ="wat_pot"
combined_dat_wat_500 <- rbind(leaf_wat_no_damage_500, leaf_wat_damage_500)
#plot leaf water potential of damaged and undamaged leaves
boxplot(combined_dat_wat_500$wat_pot~combined_dat_wat_500$treatment, ylim=c(0.4,1.5))
plot(results500_damage_cor1_wat_growing[148000:148500,]$mean_leaf_wat_pot_damage, ylim=c(0.4,1.4))
#check conditions for ANOVA
combined_dat_wat_500$treatment <- as.factor(combined_dat_wat_500$treatment)
str(combined_dat_wat_500)
lm1 <- lm(data = combined_dat_wat_500, (wat_pot^3.9)~treatment)
#plot(resid(lm1))
hist(resid(lm1))
#hist(combined_dat_wat_500$wat_pot)
ANOVA1 <- aov(lm1)
summary(ANOVA1)
#post hoc test (Tukey)
glht<-glht(lm1,linfct=mcp(treatment="Tukey")) #Tukey Test
summary(glht) #result table with all comparisons
cld(glht) #Subgroup letters
#boxplots of final fruit number per treatment
combined_dat_wat_500$wat_pot <- combined_dat_wat_500$wat_pot * -1
combined_dat_wat_500$wat_pot
boxplot(combined_dat_wat_500$wat_pot~combined_dat_wat_500$treatment, par(cex.axis=0.8), 
        col=c("red", "green"), boxwex=.5, 
        xlab = "Model version", ylab = "Mean leaf water potential[HPa]", ylim=c(-1.5,-0))
median(combined_dat_wat_500[1:675000,]$wat_pot)
sd(combined_dat_wat_500[1:675000,]$wat_pot)
median(combined_dat_wat_500[675001:1328428,]$wat_pot)
sd(combined_dat_wat_500[675001:1328428,]$wat_pot)
letters <- c("median = -0.885", "median = -1.409")
text(1:2, -0.3, letters, cex=0.8)
letters <- c("a","b")
text(1:2, -0.1, letters, cex=0.8)
plot((results500_damage_cor1_wat[32:80,]$mean_leaf_wat_pot) * (-1), ylim=c(-1.5,-0.1), 
     ylab="Leaf water potential [MPa]", xlab="Half weekly timesteps from mid May - mid September", 
     col="green", cex=0.8)
points((results500_damage_cor1_wat[32:80,]$mean_leaf_wat_pot_damage) * (-1), col = "red", cex = 0.8)
legend("topleft", c("no damage", "damage"),
       col=c("green", "red"), title="Model version", horiz=TRUE, 
       pch=1, cex=0.65)

#unsuccessful approaches reading in lists in matrix output
#transformed_trial <- as.data.frame(t(trial))
#str(transformed_trial)
#View(transformed_trial1)
#transformed_trial1 <- as.vector(transformed_trial)
#str(transformed_trial1)
#transformed_trial1

#investigate net assimilation in relation to leaf water potential for infested and
#uninfested trees
#data need to be selected for growing season
results500_damage_cor1_wat_growing <- subset(results500_damage_cor1_wat, week_year >= 16 & week_year <= 38)
results500_damage_cor1_wat_growing$week_year
results500_damage_cor1_wat_growing$mean_leaf_wat_pot_damage
plot(results500_damage_cor1_wat_growing$mean_net_phot~results500_damage_cor1_wat_growing$mean_leaf_wat_pot,
     col = "blue", ylim=c(0.3,4.5), xlim=c(0.5,1.5))
points(results500_damage_cor1_wat_growing$mean_net_phot_damage~results500_damage_cor1_wat_growing$mean_leaf_wat_pot_damage, 
       col = "purple")
#select only those data with low damaged leaf water potential
results500_damage_cor1_wat_growing_low <- subset(results500_damage_cor1_wat_growing, mean_leaf_wat_pot_damage >= 0.5 & mean_leaf_wat_pot_damage <= 1.28)
results500_damage_cor1_wat_growing_low1 <- subset(results500_damage_cor1_wat_growing, mean_leaf_wat_pot_damage <= 0.7)
#create combined dataframe
treatment <- (rep("no_damage", 71152))
leaf_wat_phot_no_damage_500 <- data.frame(results500_damage_cor1_wat_growing_low1$mean_net_phot, treatment)
colnames(leaf_wat_phot_no_damage_500)[colnames(leaf_wat_phot_no_damage_500) == "results500_damage_cor1_wat_growing_low1.mean_net_phot"] ="net_phot"
#secondly for leaf water potential with damage
treatment <- (rep("damage", 71152))
leaf_wat_phot_damage_500 <- data.frame(results500_damage_cor1_wat_growing_low1$mean_net_phot_damage, treatment)
colnames(leaf_wat_phot_damage_500)[colnames(leaf_wat_phot_damage_500) == "results500_damage_cor1_wat_growing_low1.mean_net_phot_damage"] ="net_phot"
str(leaf_wat_phot_no_damage_500)
combined_dat_wat_phot_500 <- rbind(leaf_wat_phot_no_damage_500, leaf_wat_phot_damage_500)
boxplot(combined_dat_wat_phot_500$net_phot~combined_dat_wat_phot_500$treatment)
#median net assimilation without damage
median(combined_dat_wat_phot_500[1:71152,]$net_phot)
#median net assimilation with damage
median(combined_dat_wat_phot_500[71153:142304,]$net_phot)
#check conditions for ANOVA
combined_dat_wat_phot_500$treatment <- as.factor(combined_dat_wat_phot_500$treatment)
str(combined_dat_wat_phot_500)
lm1 <- lm(data = combined_dat_wat_phot_500, net_phot~treatment)
plot(resid(lm1))
hist(resid(lm1))
hist(combined_dat_wat_phot_500$net_phot)
ANOVA1 <- aov(lm1)
summary(ANOVA1)
#post hoc test (Tukey)
glht<-glht(lm1,linfct=mcp(treatment="Tukey")) #Tukey Test
summary(glht) #result table with all comparisons
cld(glht) #Subgroup letters
boxplot(combined_dat_wat_phot_500$net_phot~combined_dat_wat_phot_500$treatment, 
        col=c("red","green"), par(cex.axis=0.8), boxwex=.5, 
        xlab = "Model version", ylab = "Mean net assimilation", ylim=c(0,7))
#median net assimilation without damage
median(combined_dat_wat_phot_500[1:71152,]$net_phot)
#median net assimilation with damage
median(combined_dat_wat_phot_500[71153:142304,]$net_phot)
letters <- c("median = 2.939", "median=3.049")
text(1:2, 6, letters, cex=0.8)
letters <- c("a","b")
text(1:2, 6.8, letters, cex=0.8)

#for checking size of single objects of current work space
for (thing in ls()) { message(thing); print(object.size(get(thing)), units='auto') }
#try to save data with saveRDS function
saveRDS(results500_damage_cor1_wat, file = "results500_damage_cor1_wat.rds")

#leaf miner population development of selected years
#year 1 model run 1
plot(results500_damage_submit[1:104,]$`count leaf_miners`, col = "red", 
     xlab = "half-weekly timesteps over the course of one year",
     ylab = "Leaf miner population size", main = "Year 1 model run 1")
lines(results500_damage_submit[1:104,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[1:104,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[1:104,]$`count leaf_miners`, col = "blue")
legend("topleft", c("damage no learning", "damage learning"),
       col=c("red", "blue"), title="Leaf mining behaviour", horiz=FALSE, 
       pch=1, cex=0.65)
#year 15 model run 1
plot(results500_damage_submit[1560:1664,]$`count leaf_miners`, col = "red",
     xlab = "half-weekly timesteps over the course of one year",
     ylab = "Leaf miner population size", main = "Year 15 model run 1")
lines(results500_damage_submit[1560:1664,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[1560:1664,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[1560:1664,]$`count leaf_miners`, col = "blue")
legend("topleft", c("damage no learning", "damage learning"),
       col=c("red", "blue"), title="Leaf mining behaviour", horiz=FALSE, 
       pch=1, cex=0.65)
#year 30 model run 1
plot(results500_damage_submit[3016:3120,]$`count leaf_miners`, col = "red",
     xlab = "half-weekly timesteps over the course of one year",
     ylab = "Leaf miner population size", main = "Year 30 model run 1")
lines(results500_damage_submit[3016:3120,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[3016:3120,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[3016:3120,]$`count leaf_miners`, col = "blue")
legend("topleft", c("damage no learning", "damage learning"),
       col=c("red", "blue"), title="Leaf mining behaviour", horiz=FALSE, 
       pch=1, cex=0.65)
#year 1 model run 100
plot(results500_damage_submit[10400:10504,]$`count leaf_miners`, col = "red")
lines(results500_damage_submit[10400:10504,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[10400:10504,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[10400:10504,]$`count leaf_miners`, col = "blue")
#year 15 model run 100
plot(results500_damage_submit[11960:12064,]$`count leaf_miners`, col = "red")
lines(results500_damage_submit[11960:12064,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[11960:12064,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[11960:12064,]$`count leaf_miners`, col = "blue")
#year 30 model run 100
plot(results500_damage_submit[13416:13520,]$`count leaf_miners`, col = "red")
lines(results500_damage_submit[13416:13520,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[13416:13520,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[13416:13520,]$`count leaf_miners`, col = "blue")
#year 1 model run 200
plot(results500_damage_submit[20800:20904,]$`count leaf_miners`, col = "red")
lines(results500_damage_submit[20800:20904,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[20800:20904,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[20800:20904,]$`count leaf_miners`, col = "blue")
#year 15 model run 200
plot(results500_damage_submit[22360:22464,]$`count leaf_miners`, col = "red")
lines(results500_damage_submit[22360:22464,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[22360:22464,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[22360:22464,]$`count leaf_miners`, col = "blue")
#year 30 model run 200
plot(results500_damage_submit[23816:23920,]$`count leaf_miners`, col = "red")
lines(results500_damage_submit[23816:23920,]$`count leaf_miners`, col = "red")
points(results500_damage_learning_submit[23816:23920,]$`count leaf_miners`, col = "blue")
lines(results500_damage_learning_submit[23816:23920,]$`count leaf_miners`, col = "blue")

#leaf miner population development of selected years from virtual ecologist sampling
#year 25 model run 1
plot(results500_damage_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "red",
     xlab = "half-weekly timesteps over the course of one year",
     ylab = "Sampled leaf miner population size", main = "Year 25 model run 1")
lines(results500_damage_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "red")
points(results500_damage_learning_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "blue")
lines(results500_damage_learning_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "blue")
legend("topleft", c("damage no learning", "damage learning"),
       col=c("red", "blue"), title="Leaf mining behaviour", horiz=FALSE, 
       pch=1, cex=0.65)
#leaf miner population development of selected years from virtual ecologist sampling
#year 25 model run 2
plot(results500_damage_submit[8330:8434,]$`sum [virtual_count] of patches` * 10, col = "red",
     xlab = "half-weekly timesteps over the course of one year",
     ylab = "Sampled leaf miner population size", main = "Year 25 model run 2")
lines(results500_damage_submit[8330:8434,]$`sum [virtual_count] of patches` * 10, col = "red")
points(results500_damage_learning_submit[8330:8434,]$`sum [virtual_count] of patches` * 10, col = "blue")
lines(results500_damage_learning_submit[8330:8434,]$`sum [virtual_count] of patches` * 10, col = "blue")
legend("topleft", c("damage no learning", "damage learning"),
       col=c("red", "blue"), title="Leaf mining behaviour", horiz=FALSE, 
       pch=1, cex=0.65)#leaf miner population development of selected years from virtual ecologist sampling
#year 25 model run 1
plot(results500_damage_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "red",
     xlab = "half-weekly timesteps over the course of one year",
     ylab = "Leaf miner population size", main = "Year 25 model run 1")
lines(results500_damage_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "red")
points(results500_damage_learning_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "blue")
lines(results500_damage_learning_submit[2600:2704,]$`sum [virtual_count] of patches` * 10, col = "blue")
legend("topleft", c("damage no learning", "damage learning"),
       col=c("red", "blue"), title="Leaf mining behaviour", horiz=FALSE, 
       pch=1, cex=0.65)

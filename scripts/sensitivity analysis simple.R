#nlrx package
#create a nl project
#install.packages("nlrx")
nlrx::download_netlogo(to = "~/", version = "6.2.0", extract = TRUE)
library(nlrx)
library(tidyverse)
library(ggrepel)
getwd()
a <- read.delim("/home/felix/egg_number.txt")
#list.files(path="./Netlogo", pattern=NULL, all.files=FALSE,
#           full.names=FALSE)

netlogopath <- file.path("/home/felix/NetLogo1")
modelpath <- file.path(netlogopath, "APPLE POPDYN model 2D submit 6.2.0")
outpath <- file.path("/home/felix")

#create nl project
nl500 <- nl(nlversion = "6.2.0",
            nlpath = netlogopath,
            modelpath = modelpath,
            jvmmem = 1024)

nl500@experiment <- experiment(expname="leaf_number_no_damage_500",
                               outpath=outpath,
                               repetition=1,
                               tickmetrics="true",
                               idsetup="setup",
                               idgo="go",
                               runtime=3120,
                               evalticks=NA_integer_,
                               metrics=c("count leaves","count leaf_miners",
                                         "mean_net_phot","mean_net_phot_damage"),
                               variables = list('minPARi' = list(min=100, max=400, step=100, qfun="qunif"), 
                                                'maxPARi' = list (min=700, max=1300, step=100, qfun="qunif"),
                                                'start_growth' = list(min=14, max=18, step=2, qfun="qunif"),
                                                'end_growth' = list(min=36, max=40, step=2, qfun="qunif"),
                                                'max_empty_mines' = list(min=100, max=400, step=100, qfun="qunif"),
                                                'mort_threshold' = list(min=1.5, max=2, step=0.1, qfun="qunif"))
)

nl500@simdesign <- simdesign_lhs(nl=nl500,
                                 samples=10,
                                 nseeds=4,
                                 precision=3)

library(future)
plan(multisession)
results500_damage_sens <- run_nl_all(nl = nl500)

# Attach results to nl object:
#setsim(nl1000, "simoutput") <- results1000
# Write output to outpath of experiment within nl
#write_simoutput(nl100)

# attach results to nl object
setsim(nl500, "simoutput") <- results500_damage_sens
print(nl500)

#analyze nl object
morris_analyzed <- analyze_nl(nl500)

#Aggregate means of mu/mustar/sigma for every parameter for all seeds
morris_split <- pivot_wider(morris_analyzed, names_from = index, values_from = value)
mustar_mean <- tapply(morris_split$mustar, morris_split$parameter, mean)
mu_mean <-tapply(morris_split$mu, morris_split$parameter, mean)
sigma_mean <- tapply(morris_split$sigma, morris_split$parameter, mean)

#Aggregate standard deviations of mu/mustar/sigma for every parameter for all seeds
mustar_sd <- tapply(morris_split$mustar, morris_split$parameter, sd)
mu_sd <-tapply(morris_split$mu, morris_split$parameter, sd)
sigma_sd <- tapply(morris_split$sigma, morris_split$parameter, sd)

#Create table with means and standard_deviations
parameter <- names(sigma_mean)
morris_aggregated <- data.frame(parameter, mu_mean,mustar_mean,sigma_mean,mu_sd,mustar_sd,sigma_sd)

# plot results
mustarsig <- ggplot() +
  #facet_wrap(~output, nrow=3, scales="free") +
  # geom_ribbon(data=ribbon, aes(x=x, ymin=ymin, ymax=ymax, fill=Effect), color="white", alpha=0.3) +
  geom_point(data=morris_aggregated, aes(x=mustar_mean, y=sigma_mean), size=3)+
  geom_text_repel(data=morris_aggregated, aes(x=mustar_mean, y=sigma_mean, label=parameter), size=4, force=7, box.padding = 0.25, point.padding=0.1, max.iter = 1000)+
  theme_bw() +
  labs(
    captions = "",
    x = expression(mu*"*"),
    y = expression(sigma*""),
    title = "Morris Screening",
    subtitle = "of FRUIT model")
mustarsig
}

plot(results500_damage_sens$`count leaf_miners`)

# same procedure for latin hypercube
# attach results to nl object
setsim(nl500, "simoutput") <- results500_damage_sens
print(nl500)

#analyze nl object
#morris <- analyze_nl(`wolf-sheep_morris_nl_object`)
test <- analyze_nl(nl_ff)
lhs_analyzed <- analyze_nl(nl500, metrics = getexp(nl500, "metrics"), funs = list(mean = mean))
str(lhs_analyzed)
myfuns <- list(mean=mean, sd=sd, min=min, max=max)
lhs_analyzed1 <- analyze_nl(nl500, funs = myfuns)
str(lhs_analyzed1)
plot(lhs_analyzed1$max_empty_mines)
plot(lhs_analyzed1$mean_net_phot_sd)
plot(lhs_analyzed$`count leaf_miners_mean`~lhs_analyzed$mort_threshold)

# calculate a multiple linear regression model with the two changed input parameters
# investigate different combination of two parameters each time
m1 <- lm(lhs_analyzed$`count leaves_mean` ~ lhs_analyzed$minPARi * lhs_analyzed$maxPARi)
summary(m1)

# check linear model assumptions -> normality is rather ok
#par(mfrow=c(2, 2))
plot(m1)

#par(mfrow=c(1, 1))

# standardize model coefficients (excluding the Intercept)
#summary(m1)$coefficients
pure_coefficients <- summary(m1)$coefficients[-1, 1]  # -1 removes the Intercept
standard_errors <- summary(m1)$coefficients[-1, 2]  # -1 removes the Intercept
standardized_coefficients <- pure_coefficients / standard_errors

# normalize standardized model coefficients to obtain sensitivities
absolute_standardized_coefficients <- abs(standardized_coefficients)
summed_standard_coefs <- sum(absolute_standardized_coefficients)
(sensitivities <- absolute_standardized_coefficients / summed_standard_coefs)

# plot sensitivities
barplot(sensitivities, 
        names.arg=c("minPARi", "maxPARi", "interactions"), 
        xlab="parameters",
        ylab="sensitivities",
        ylim=c(0, 1),
        col="black")

# repeat same procedure for leaf miner population output
# calculate a multiple linear regression model with the two changed input parameters
# investigate different combination of two parameters each time
m2 <- lm(lhs_analyzed$`count leaf_miners_mean` ~ lhs_analyzed$max_empty_mines * lhs_analyzed$mort_threshold)
summary(m2)

# check linear model assumptions -> normality is rather ok
#par(mfrow=c(2, 2))
plot(m2)
#par(mfrow=c(1, 1))

# standardize model coefficients (excluding the Intercept)
#summary(m1)$coefficients
pure_coefficients <- summary(m2)$coefficients[-1, 1]  # -1 removes the Intercept
standard_errors <- summary(m2)$coefficients[-1, 2]  # -1 removes the Intercept
standardized_coefficients <- pure_coefficients / standard_errors

# normalize standardized model coefficients to obtain sensitivities
absolute_standardized_coefficients <- abs(standardized_coefficients)
summed_standard_coefs <- sum(absolute_standardized_coefficients)
(sensitivities <- absolute_standardized_coefficients / summed_standard_coefs)

# plot sensitivities
barplot(sensitivities, 
        names.arg=c("max_empty_mines", "mort_threshold", "interactions"), 
        xlab="parameters",
        ylab="sensitivities",
        ylim=c(0, 1),
        col="black")

# repeat same procedure for vegetation period output
# calculate a multiple linear regression model with the two changed input parameters
# investigate different combination of two parameters each time
m3 <- lm(lhs_analyzed$`count leaves_mean` ~ lhs_analyzed$start_growth * lhs_analyzed$end_growth)
summary(m3)

# check linear model assumptions -> normality is rather ok
#par(mfrow=c(2, 2))
plot(m3)
#par(mfrow=c(1, 1))

# standardize model coefficients (excluding the Intercept)
#summary(m1)$coefficients
pure_coefficients <- summary(m3)$coefficients[-1, 1]  # -1 removes the Intercept
standard_errors <- summary(m3)$coefficients[-1, 2]  # -1 removes the Intercept
standardized_coefficients <- pure_coefficients / standard_errors

# normalize standardized model coefficients to obtain sensitivities
absolute_standardized_coefficients <- abs(standardized_coefficients)
summed_standard_coefs <- sum(absolute_standardized_coefficients)
(sensitivities <- absolute_standardized_coefficients / summed_standard_coefs)

# plot sensitivities
barplot(sensitivities, 
        names.arg=c("start_growth", "end_growth", "interactions"), 
        xlab="parameters",
        ylab="sensitivities",
        ylim=c(0, 1),
        col="black")

# interaction plots for leaf number outputs
# create color vector
plot_colors = palette(rainbow(6))

# get parameter values for wolve/sheep_gain_from_food
minPARi_levels = unique(lhs_analyzed$minPARi)
maxPARi_levels =  unique(lhs_analyzed$maxPARi)

# plot results of simulations
plot(lhs_analyzed$`count leaves_mean` ~ lhs_analyzed$minPARi)

# plot linear models for different levels of sheep_gain_from_food
for (i in 1:length(minPARi_levels)){
  # sheep_gain_from_food for this iteration
  minPARilevel <- minPARi_levels[i]
  # extract simulations of that level
  sub_data <- lhs_analyzed[lhs_analyzed$minPARi == minPARilevel,]
  # compute linear model for that level
  sub_lm <- lm(lhs_analyzed$`count leaves_mean` ~ lhs_analyzed$maxPARi)
  # and add it to the plot
  abline(sub_lm, col = plot_colors[i])
}

# create legend entry
legend(x = "right",
       legend=minPARi_levels,
       title="minPARi",
       lty = 1,
       col=plot_colors[1:length(minPARi_levels)])
title("interaction plot")

# plot results of simulations
plot(lhs_analyzed$`count leaves_mean` ~ lhs_analyzed$minPARi)
# plot linear models for different levels of wolf_gain_from_food
for (i in 1:length(maxPARi_levels)){
  # wolf_gain_from_food for this iteration  
  maxPARilevel <- maxPARi_levels[i]
  # extract simulations of that level
  sub_data <- lhs_analyzed[lhs_analyzed$maxPARi == maxPARilevel,]
  # compute linear model for that level
  sub_lm <- lm(lhs_analyzed$`count leaves_mean` ~ lhs_analyzed$maxPARi)
  # and add it to the plot
  abline(sub_lm, col = plot_colors[i])
}
# create legend entry
legend(x = "topright", legend=maxPARi_levels, title="maxPARi", lty = 1, col=plot_colors[1:length(maxPARi_levels)])
title("interaction plot")

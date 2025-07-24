#nlrx package
#create a nl project
#install.packages("nlrx")
nlrx::download_netlogo(to = "~/", version = "6.2.0", extract = TRUE)
library(nlrx)
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

nl500@experiment <- experiment(expname="leaf_number_damage_500_submit",
                               outpath=outpath,
                               repetition=1,
                               tickmetrics="true",
                               idsetup="setup",
                               idgo="go",
                               runtime=3120,
                               evalticks=NA_integer_,
                               metrics=c("count leaves","count leaf_miners", "count fruits",
                                         "mean_net_phot","mean_net_phot_damage",
                                         "mean_leaf_wat_pot",
                                         "mean_plant_vigor",
                                         "sum [virtual_count] of patches",
                                         "[(who) + (plant_vigor)] of leaves",
                                         "[(who) + (mined_area_per_leaf / 100)] of leaves",
                                         "[(who) + (leaf_water_potential_soil_damage / 2)] of leaves",
                                         "[(who) + (leaf_water_potential_damage / 2)] of leaves",
                                         "[(who) + (net_assimilation_with_damage / 10)] of leaves"),
                               variables = list('minPARi' = list(min=200, max=200, qfun="qunif"))
)

nl500@simdesign <- simdesign_lhs(nl=nl500,
                                 samples=1,
                                 nseeds=500,
                                 precision=3)

library(future)
plan(multisession)
results500_damage_submit <- run_nl_all(nl = nl500)

# Attach results to nl object:
setsim(nl1000, "simoutput") <- results1000
# Write output to outpath of experiment within nl
write_simoutput(nl100)

print(nl500)
??run_nl_all()

library(parallel)
availableCores()

plot(results500_damage_no_learning$`random-seed`)
lines(results500_damage_no_learning$`random-seed`)

write.csv(results500_damage_submit, file = "results500_damage_learning_submit.csv")

quit()

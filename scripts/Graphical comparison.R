################################################################################
# 1. Comparison of simulated and compared net assimilation #####################
################################################################################

getwd()
setwd("C:/Users/haeffner/Documents/ecological modelling/data")

#read in simulated and observed net assimilation
Sim_net_assimilation <- read.delim("Simulated net assimilation.txt", sep = ";", dec = ",", header = TRUE)
Obs_net_assimilation <- read.delim("Observed net assimilation.txt", sep = ";", dec = ",", header = TRUE)

Obs_net_assimilation$Observed <- Obs_net_assimilation$Observed * (50/30)

plot(Sim_net_assimilation, ylim = c(0,42), xlim = c(0,60), 
     main = "Comparison of simulated net assimilation rates with field data", 
     xlab = "One growing season May - November[half-weekly timesteps]", 
     ylab = "Net assimilation[mg dm^-2 hr^-1]", col = "forestgreen")
lines(Sim_net_assimilation, col = "forestgreen")
points(Obs_net_assimilation, col = "blue")
lines(Obs_net_assimilation, col = "blue")
legend(1, 40, legend=c("Simulated", "Observed"), fill=c("forestgreen", "blue"), 
       cex=0.75, text.font=7)

#assess maxima and minima of datasets
#install.packages("splus2R")
library(splus2R)
max(Sim_net_assimilation$Simulated)
max(Obs_net_assimilation$Observed)
peaks(Sim_net_assimilation$Simulated)
peaks(Obs_net_assimilation$Observed)
Sim_net_assimilation_max <- subset(Sim_net_assimilation, peaks(Sim_net_assimilation$Simulated) == TRUE)

Sim_net_assimilation_max_dif <- vector()
for (i in 1:length(Sim_net_assimilation_max$Time_step)) {
  Sim_net_assimilation_max_dif[i] <- Sim_net_assimilation_max$Time_step[i+1] - Sim_net_assimilation_max$Time_step[i]
}
      
Obs_net_assimilation_max <- subset(Obs_net_assimilation, peaks(Obs_net_assimilation$Observed) == TRUE)

Obs_net_assimilation_max_dif <- vector()
for (i in 1:length(Obs_net_assimilation_max$Time)) {
  Obs_net_assimilation_max_dif[i] <- Obs_net_assimilation_max$Time[i+1] - Obs_net_assimilation_max$Time[i]
}


################################################################################
# 2. Comparison of simulated and observed leaf miner demographics ##############
################################################################################

# Generate 4 different sets of outputs
getwd()
setwd("C:/Users/haeffner/Documents/ecological modelling/data")
y1 <- read.delim("Missouri leaf miner demographics grand pas.txt", sep = ";", dec = ",", header = FALSE)
y2 <- read.delim("Missouri leaf miner demographics waverly 1991.txt", sep = ";", dec = ",", header = FALSE)
y3 <- read.delim("Simulated leaf miner demographics year 15 model run 1.txt", sep = ";", dec = ",", header = FALSE)
y4 <- read.delim("Simulated leaf miner demographics year 15 model run 1 learning.txt", sep = ";", dec = ",", header = FALSE)
y5 <- read.delim("Missouri leaf miner demographics grand pas 1992.txt", sep = ";", dec = ",", header = FALSE)
y6 <- read.delim("Missouri leaf miner demographics waverly 1992.txt", sep = ";", dec = ",", header = FALSE)
y7 <- read.delim("Simulated leaf miner demographics year 30 model run 1 damage.txt", sep = ";", dec = ",", header = FALSE)
y8 <- read.delim("Simulated leaf miner demographics year 30 model run 1 learning.txt", sep = ";", dec = ",", header = FALSE)
y <- list(y1, y2, y3, y4)

# The data have a common independent variable (x)
x <- nrow(y1)

# Colors for y[[2]], y[[3]], y[[4]] points and axes
colors = c("forestgreen", "blue", "red")

# Set the margins of the plot wider
par(oma = c(0, 2, 2, 3))

plot(y[[1]]$V1, y[[1]]$V2, yaxt = "n", xlab = "Half-weekly timesteps since first day of the year", main = "Observed and simulated leaf miner demographics 1991", 
     ylab = "")
lines(y[[1]]$V1, y[[1]]$V2)

# We use the "pretty" function go generate nice axes
axis(at = pretty(y[[1]]$V2), side = 2)

# The side for the axes.  The next one will go on 
# the left, the following two on the right side
sides <- list(2, 4, 4) 

# The number of "lines" into the margin the axes will be
lines <- list(2, NA, 2)

for(i in 2:4) {
  par(new = TRUE)
  plot(y[[i]]$V1, y[[i]]$V2, axes = FALSE, col = colors[i-1], xlab = "", ylab = "")
  axis(at = pretty(y[[i]]$V2), side = sides[[i-1]], line = lines[[i-1]], 
       col = colors[i-1])
  lines(y[[i]]$V1, y[[i]]$V2, col = colors[i-1])
  legend(21, 23000, legend=c("Observed_Grand_Pas", "Observed_Waverly", "Simulated_damage", "Simulated_damage_learning"), 
         fill=c("black", "forestgreen", "red", "blue"), cex=0.75, text.font=7)
}

# Profit.

#assess maxima and minima of datasets
#install.packages("splus2R")
library(splus2R)
max(y1)
max(y2)
max(y3)
max(y4)
peaks(y1)
peaks(y2)
peaks(y3)
peaks(y4)
y1_max <- subset(y1, peaks(y1$V2) == TRUE)
y2_max <- subset(y2, peaks(y2$V2) == TRUE)
y3_max <- subset(y3, peaks(y3$V2) == TRUE)
y4_max <- subset(y4, peaks(y4$V2) == TRUE)

y1_max_dif <- vector()
for (i in 1:length(y1_max$V1)) {
  y1_max_dif[i] <- y1_max$V1[i+1] - y1_max$V1[i]
}

y2_max_dif <- vector()
for (i in 1:length(y2_max$V1)) {
  y2_max_dif[i] <- y2_max$V1[i+1] - y2_max$V1[i]
}

y3_max_dif <- vector()
for (i in 1:length(y3_max$V1)) {
  y3_max_dif[i] <- y3_max$V1[i+1] - y3_max$V1[i]
}

y4_max_dif <- vector()
for (i in 1:length(y4_max$V1)) {
  y4_max_dif[i] <- y4_max$V1[i+1] - y4_max$V1[i]
}


#create multipanel figure from different datasets
#correct waverly dataset
y1$V2 <- y1$V2 * (1/3)
y6$V2 <- y6$V2 * 1.5

layout(matrix(c(1,2,3,4), 2, 2, byrow = T)) 
layout.show(n=4) 

layout <- plot(y2$V2~y2$V1, main = "Observed 1991", xlab = "Half-weekly timesteps since first day of the year", ylab = "Leaf miner population size", col = "orange")
          lines(y2$V2~y2$V1, col = "orange")
          points(y1$V2~y1$V1, col = "forestgreen")
          lines(y1$V2~y1$V1, cole = "forestgreen")
          legend(21, 23000, legend=c("Observed_Waverly", "Observed_Grand_Pas"), 
                 fill=c("orange", "forestgreen"), cex=0.75, text.font=7)
layout <- plot(y6$V2~y6$V1, main = "Observed 1992", xlab = "Half-weekly timesteps since first day of the year", ylab = "Leaf miner population size", col = "orange")
          lines(y6$V2~y6$V1, col = "orange")
          points(y5$V2~y5$V1, col = "forestgreen")
          lines(y5$V2~y5$V1, col = "forestgreen")
          legend(21, 15500, legend=c("Observed_Waverly", "Observed_Grand_Pas"), 
                 fill=c("orange", "forestgreen"), cex=0.75, text.font=7)
layout <- plot(y3$V2~y3$V1, main = "Year 15 model run 1", xlab = "Half-weekly timesteps since first day of the year", ylab = "Leaf miner population size", col = "red")
          lines(y3$V2~y3$V1, col = "red")
          points(y4$V2~y4$V1, col = "blue")
          lines(y4$V2~y4$V1, col = "blue")
          legend(18, 11000, legend=c("Simulated_damage", "Simulated_damage_learning"), 
                 fill=c("red", "blue"), cex=0.75, text.font=7)
layout <- plot(y7$V2~y7$V1, main = "Year 30 model run 1", xlab = "Half-weekly timesteps since first day of the year", ylab = "Leaf miner population size", col = "red")
          lines(y7$V2~y7$V1, col = "red")
          points(y8$V2~y8$V1, col = "blue")
          lines(y8$V2~y8$V1, col = "blue")
          legend(20, 57000, legend=c("Simulated_damage", "Simulated_damage_learning"), 
                 fill=c("red", "blue"), cex=0.75, text.font=7)


################################################################################
# 3. Comparison of mean leaf miner populations with mean leaf numbers ##########
################################################################################

getwd()
setwd("C:/Users/haeffner/Documents/ecological modelling/data")

#read in simulated and observed net assimilation
mean_damage <- read.delim("leaf miner leaf number damage.txt", sep = ";", dec = ",", header = TRUE)
mean_damage_learning <- read.delim("leaf miner leaf number damage learning.txt", sep = ";", dec = ",", header = TRUE)

plot(mean_damage, ylim = c(0,3000), xlim = c(0,800), 
     main = "Relationship of leaf miner populations with leaf numbers", 
     xlab = "Mean leaf numbers of all model runs", 
     ylab = "Mean leaf miner population of all model runs", col = "red")
#lines(mean_damage, col = "red")
points(mean_damage_learning, col = "blue")
#lines(mean_damage_learning, col = "blue")
legend(0, 3000, legend=c("Tolerant leaf miners", "Picky leaf miners"), fill=c("red", "blue"), 
       cex=0.75, text.font=7)


################################################################################
# 4. Leaf number ###############################################################
################################################################################

getwd()
setwd("C:/Users/haeffner/Documents/ecological modelling/data")

leaf_number <- read.delim("leaf number.txt", sep = ";", dec = ",", header = TRUE)
str(leaf_number)

plot(leaf_number, main = "Temporal development of leaf numbers", xlab = "Simulation year", ylab = "Total leaf number")


################################################################################
# 5. Model validation leaf mines ###############################################
################################################################################

leaf_data <- read.delim("Missouri orchards leaf data.txt", sep = ",", header = TRUE)
leaf_data$location <- as.factor(leaf_data$location)
leaf_data$location <- factor(leaf_data$location, levels = c("Model", "Grand Pass", "Huffstutter", "Waverly"))
colors <- c("darkred", "gray", "gray", "gray")
plot(leaf_data$total~leaf_data$location, xlab = "Location", ylab = "Total leaf mines per leaf", col = colors)

# compare different simulated years 
leaf_data <- read.delim("Missouri orchards leaf data.txt", sep = ",", header = TRUE)
leaf_data$location[7:8] <- c("Model (Tree age 20 - 21)", "Model (Tree age 20 - 21)")
leaf_data$location[15:16] <- c("Model (Tree age 29 - 30)", "Model (Tree age 29 - 30)")
leaf_data_years <- leaf_data[c(1:8, 15:16),]
leaf_data_years$location <- as.factor(leaf_data_years$location)
leaf_data_years$location <- factor(leaf_data_years$location, levels = c("Model (Tree age 20 - 21)", "Model (Tree age 29 - 30)", "Grand Pass", "Huffstutter", "Waverly"))
colors <- c("darkred", "darkred", "gray", "gray", "gray")
plot(leaf_data_years$total ~ leaf_data_years$location, xlab = "Location", ylab = "Total leaf mines per leaf", col = colors, cex.axis=0.75)

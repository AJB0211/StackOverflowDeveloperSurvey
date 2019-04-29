



censusDegree <- c("Secondary","Post-Secondary","Bachelor's","Master's","Associate's","Professional","Doctoral","None")
censusCount <- c(70882,46750,47718,20187,13507+9893,3210,4006,815)
censusRatios <- censusCount/sum(censusCount)

censusFrame <- data.frame(Education = censusDegree, rate = censusRatios)
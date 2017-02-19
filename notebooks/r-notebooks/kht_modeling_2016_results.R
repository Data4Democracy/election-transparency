for_rf <- data2016 %>%
  mutate(propMfg1970 = MfgEmp1970 / TotalEmp1970,
         propMfg1980 = MfgEmp1980 / TotalEmp1980,
         propMfg1990 = MfgEmp1990 / TotalEmp1990,
         propMfg2001 = MfgEmp2001 / TotalEmp2001,
         NCHS_UrbanRural1990 = factor(NCHS_UrbanRural1990),
         NCHS_UrbanRural2006 = factor(NCHS_UrbanRural2006),
         NCHS_UrbanRural2013 = factor(NCHS_UrbanRural2013)) %>%
  select(rDRPct, MedianHouseholdIncome, TotalPopulation, propMale, propKids, propAdultsNoTeens, propNMarried,
         propHispanic, propWhite, propBlack, SimpsonDiversityIndex,
         propNoHS, propHS, propMoreHS,
         propMfg1970, propMfg1980, propMfg1990, propMfg2001, propMfg2015, propUnemp, propLaborForce,
         MedianHousingCosts, MedianHouseholdIncome,
         NCHS_UrbanRural1990, NCHS_UrbanRural2006, NCHS_UrbanRural2013) %>%
  filter(!is.na(MedianHouseholdIncome),
         !is.na(propMfg1970), !is.na(propMfg1980), !is.na(propMfg1990), !is.na(propMfg2001), !is.na(propMfg2015),
         !is.na(NCHS_UrbanRural1990), !is.na(NCHS_UrbanRural2013), !is.na(NCHS_UrbanRural2006))

library(randomForest)
library(caret)
library(modelr)

trIndex <- createDataPartition(for_rf$rDRPct, p = 0.8, list = F)
tr <- for_rf[trIndex,]
te <- for_rf[-trIndex,]

rf <- randomForest(rDRPct ~ ., tr)
varImpPlot(rf)
te %>% add_predictions(rf) %>% ggplot(aes(rDRPct, pred)) + geom_point()

## Well that's a darn good signal
## What contributes?
rf <- randomForest(rDRPct ~ ., for_rf)
varImpPlot(rf)

## propNMarried is easily the strongest predictor
qplot(propNMarried, rDRPct, data = for_rf)

## Correlated with propWhite
qplot(propNMarried, propWhite, data = for_rf)

## How about totalPopulation?
qplot(TotalPopulation, rDRPct, data = for_rf) + scale_x_log10()
## NEXT TIME - log transform population

## How about median housing costs?
qplot(MedianHousingCosts, rDRPct, data = for_rf)

## How about median housing costs? Not super clear, slight skew down
qplot(MedianHouseholdIncome, rDRPct, data = for_rf)

## How about education?
qplot(propNoHS, rDRPct, data = for_rf) # less clear here
qplot(propHS, rDRPct, data = for_rf) # goes up
qplot(propMoreHS, rDRPct, data = for_rf) # less clear here too, maybe goes down?

## OK, this model has MSE 0.00502
## Can we simplify it with little cost?
for_rf <- data2016 %>%
  mutate(TotalPopulationLog10 = log10(TotalPopulation)) %>% 
  select(rDRPct, MedianHouseholdIncome, TotalPopulationLog10, propMale, propKids, propAdultsNoTeens, propNMarried,
         propHispanic, propWhite, propBlack, SimpsonDiversityIndex,
         propNoHS, propHS, propMoreHS,
         MedianHousingCosts, MedianHouseholdIncome) %>%
  filter(!is.na(MedianHouseholdIncome))

rf2 <- randomForest(rDRPct ~ ., for_rf) ## MSE = 0.00530! Not bad

## How's it do on CV?
trIndex <- createDataPartition(for_rf$rDRPct, p = 0.8, list = F)
tr <- for_rf[trIndex,]
te <- for_rf[-trIndex,]

rf2 <- randomForest(rDRPct ~ ., tr)
varImpPlot(rf2)
te %>% add_predictions(rf2) %>% ggplot(aes(rDRPct, pred)) + geom_point()

## Way good! even better I think than before!
t <- te %>% add_residuals(rf2) %>% mutate(sr = resid*resid)
mean(t$sr) # 0.006 on test data

## How do the interactions work out?

library(rpart)

rp <- rpart(rDRPct ~ ., for_rf, control = rpart.control(cp = 0.01))
rpart.plot(rp, tweak = 1.5)

te %>% add_predictions(rp) %>% ggplot(aes(rDRPct, pred)) + geom_point()

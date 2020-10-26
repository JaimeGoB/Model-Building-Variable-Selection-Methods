library(caret)
library(bestglm)
library(MASS)
#reading in dataset
wine <- read.csv("winequality-white.csv", header = T, sep = ";")
wine$quality <- ifelse(wine$quality >= 7, 1, 0)
names(wine)[12] <- "good"
wine[12] <- as.factor(wine$good)

# (a) Fit a logistic regression model using all predictors and compute its test error rate. This is a repeat of what you did in the previous project.

model.lr_wine = train(as.factor(good)~., data=wine, method="glm", family="binomial",metric="Accuracy",
                      trControl=trainControl(method = "cv",number = 10))

full = glm(good~., family=binomial,wine)

lr.prob_wine = predict(full,wine,type="response")
lr.pred = ifelse(lr.prob_wine >= 0.5,1,0)

test_error = 1-mean(lr.pred == wine$good)
test_error


# (b) Use best-subset selection to find the best logistic regression model. Compute its test error rate.
res.bestglm <-  bestglm(Xy = wine,
                family = binomial,
                IC = "AIC",           # Information Criteria
                method = "exhaustive")
#We get a list of the best models
res.bestglm$BestModels
#Getting the best model with lowest AIC
res.bestglm$BestModel

# (c) Repeat (b) using forward stepwise selection.
forward <- stepAIC(full, direction = "forward", trace = FALSE)
forward$anova

# (d) Repeat (b) using backward stepwise selection.
backward <- stepAIC(full, direction = "backward", trace = FALSE)
backward$anova

# (e) Repeat (b) using ridge regression.

# (f) Repeat (b) using lasso.


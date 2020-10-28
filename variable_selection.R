library(caret)
library(bestglm)
library(glmnet)
library(MASS)

#reading in dataset
wine <- read.csv("winequality-white.csv", header = T, sep = ";")
wine$quality <- ifelse(wine$quality >= 7, 1, 0)
names(wine)[12] <- "good"

###############################################################
# (a) Fit a logistic regression model using all predictors
###############################################################

#fitting model using all predictors
full_model <- glm( as.factor(good) ~., family=binomial,wine) 

###### compute its test error rate. #######
#using CV to compute test error for full logistic model
set.seed(1234)
full_model_cv = train( as.factor(good) ~., data=wine, method="glm", family="binomial",metric="Accuracy",
                      trControl=trainControl(method = "cv",number = 10))

#getting the error using CV
test_error_full_model_cv = 1 - full_model_cv$results$Accuracy

###############################################################
# (b) Use best-subset selection to find the best logistic regression model. 
###############################################################
best_subset <- bestglm(Xy = wine,
               family = binomial,
               IC = "AIC",           # Information Criteria
               method = "exhaustive") #best-subset selection

best_subset$BestModel  #Getting the best model with lowest AIC

###### compute its test error rate. #######
#using CV to compute test error for logistic model with predictors
#from bestsubsets
set.seed(1234)
best_subset_model_cv <- train( as.factor(good) ~ fixed.acidity + volatile.acidity +
                             citric.acid + residual.sugar + chlorides +
                             free.sulfur.dioxide + density + pH + sulphates, 
                             data=wine, 
                             method="glm", 
                             family="binomial",
                             metric="Accuracy",
                             trControl=trainControl(method = "cv",number = 10))

#getting the error using CV
test_error_best_subset_model_cv = 1 - best_subset_model_cv$results$Accuracy

###############################################################
# (c) Repeat (b) using forward stepwise selection.
###############################################################
forward_selection <- bestglm(Xy = wine,
                            family = binomial,
                            IC = "AIC",         # Information Criteria
                            method = "forward") #using forward selection

#Viewing the best model
forward_selection$BestModel

###### compute its test error rate. #######
#using CV to compute test error for logistic model with predictors
#from foward selection
set.seed(1234)
forward_selection_model_cv <- train( as.factor(good) ~ fixed.acidity + volatile.acidity +
                              citric.acid + residual.sugar + chlorides +
                              free.sulfur.dioxide + density + pH + sulphates, 
                              data=wine, 
                              method="glm", 
                              family="binomial",
                              metric="Accuracy",
                              trControl=trainControl(method = "cv",number = 10))

#getting the error using CV
test_error_forward_selection_model_cv = 1 - forward_selection_model_cv$results$Accuracy

###############################################################
# (d) Repeat (b) using backward stepwise selection.
###############################################################
backward_selection <- bestglm(Xy = wine,
                             family = binomial,
                             IC = "AIC",         # Information Criteria
                             method = "backward") #using forward selection

#Viewing the best model
backward_selection$BestModel
###### compute its test error rate. #######
#using CV to compute test error for logistic model with predictors
#from foward selection
set.seed(1234)
backward_selection_model_cv <- train( as.factor(good) ~ fixed.acidity + volatile.acidity +
                                      citric.acid + residual.sugar + chlorides +
                                      free.sulfur.dioxide + density + pH + sulphates, 
                                    data=wine, 
                                    method="glm", 
                                    family="binomial",
                                    metric="Accuracy",
                                    trControl=trainControl(method = "cv",number = 10))

#getting the error using CV
test_error_backward_selection_model_cv = 1 - backward_selection_model_cv$results$Accuracy

###############################################################
# (e) Repeat (b) using ridge regression.
###############################################################

#Setting up matrices for glmnet function
y <- wine$good
x <- model.matrix(good ~ ., wine)[, -1]

#Creating a sequence of 100 values from range
grid = 10^seq(-5,10, length.out = 100)

#Perfoming 10-fold-cv to get best lambda value for ridge coefficients
#with 100 diferrent values from lambda
set.seed(1234)
cv_ridge_regression <- cv.glmnet(x,as.factor(y), alpha = 0, type.measure = "class", lambda = grid,  family = "binomial")
plot(cv_ridge_regression)

#Storing the best value for lambda
best_lambda_ridge = cv_ridge_regression$lambda.min

# fit model with best value of lambda found
ridge_model <- glmnet(x, as.factor(y), alpha = 0, lambda = best_lambda_ridge, family = binomial)
ridge_model_coefficients = ridge_model$beta

###### compute its test error rate. #######
test_error_ridge_model <- min(cv_ridge_regression$cvm)

###############################################################
# (f) Repeat (b) using lasso.
###############################################################
#Perfoming 10-fold-cv to get best lambda value for ridge coefficients
#with 100 diferrent values from lambda
set.seed(1234)
cv_lasso_regression <- cv.glmnet(x,as.factor(y), alpha = 1, type.measure = "class", lambda = grid,  family = "binomial")
plot(cv_lasso_regression)

#Storing the best value for lambda
best_lambda_lasso = cv_lasso_regression$lambda.min

# fit model with best value of lambda found
lasso_model <- glmnet(x, as.factor(y), alpha = 1, lambda = best_lambda_lasso, family = binomial)
lasso_model_coefficients = lasso_model$beta

###### compute its test error rate. #######
test_error_lasso_model <- min(cv_lasso_regression$cvm)

####################################################
#(g) Make a tabular summary of the parameter estimates and test error rates from (a) - (f). 
#Compare the results. Which model(s) would you recommend? 
#How does this recommendation compare with what you recommended in the previous project?
####################################################

all_variable_selection_methods <- rbind(test_error_full_model_cv,
                                    test_error_best_subset_model_cv,
                                    test_error_forward_selection_model_cv,
                                    test_error_backward_selection_model_cv,
                                    test_error_ridge_model,
                                    test_error_lasso_model
                                    )

colnames(all_variable_selection_methods) <- c("10-Fold-CV-Error")

rownames(all_variable_selection_methods) <- c("Full Model",
                                              "Best Subset Selection",
                                              "Forward",
                                              "Backward",
                                              "Ridge",
                                              "Lasso")

#Output in tabular format CV test error for different models
all_variable_selection_methods

# Building a Model using Normalization and Regularization Methods


The dataset contains 11 physiochemical characteristics of as predictors for White Wine. The dataset has change a little. For example, the response variables contains a range from 0-9 on the quality of wine. I have transformed this response variable, wines with quality of wine higher than 7 are considered good and lower than 7 are not.


Using this dataset I will fit a logistic regression model and perform:

- Best Subset Selection
- Forward Selection
- Backward Selection
- Rigde Regression
- Lasso Regression

To find the best model.


## Fit a logistic regression model using all predictors
The predictors are the following.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/full.png)

## Using Best-subset selection to find the best logistic regression model
The predictors are the following.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/best.png)

## Using Forward stepwise selection to find the best logistic regression model
The predictors are the following.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/forward.png)

## Using Backward stepwise selection to find the best logistic regression model
The predictors are the following.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/backward.png)


## Using Ridge Regression to find the best logistic regression model
Looking for the best model we have achieve less than 20% error rate.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/ridge_plot.png)



The predictors are the following.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/ridge.png)


## Using Lasso Regression to find the best logistic regression model
Looking for the best model we have achieve less than 20% error rate.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/lasso_plot.png)



The predictors are the following.
![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/lasso.png)

# Results

Using 10-Fold-Cross-Validation as a measure of Test Error.
**I would recommend using the model provided by Ridge Regression because it provides lowest Test Error according to CV.**

![Test Image 1](https://github.com/JaimeGoB/Model-Building-Variable-Selection-Methods/blob/main/data/results.png)






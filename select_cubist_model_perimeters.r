# Data Description
# The data being read from <coal_all.csv> contains 10 variables (Moisture, Volatile_matter, Fixed_Carbon, Ash, Hydrogen, Carbon, Nitrogen, Oxygen, Sulfur, GCV)
# Three sets of data (SET1, SET2, SET3) have been constructed based on different input variables.
#
# SET1 (Moisture, Volatile_matter, Ash, GCV)
# data[,c(1,2,4,10)]

# SET2 (Carbon, Oxygen, Sulfur, GCV)
# data[,c(6,8,9,10)]

# SET3 (Moisture, Volatile_matter, Ash, Hydrogen, Carbon, Oxygen, Sulfur, GCV)
# data[,c(1,2,4,5,6,9,10)]

# This script performs the following functions:
# (1) Reads the data and splits it into test set and training set
# (2) Uses grid search to determine two parameters of the cubist algorithm: committees and neighbors (instances)
# (3) Cubist model-based GCV prediction

#----------------------------------------------------------------1- Load data and split into training and testing sets----------------------------------

data_all <- read.csv("F://煤质论文2//coal_all.csv", header = TRUE)
#------------ Split into training and testing sets --------
set.seed(1)
nn <- 0.8
data <- data_all
# Get the length of the first column in data_noFC
sub <- sample(1:nrow(data), round(nrow(data) * nn))
length(sub)
data_train <- data[sub,] # Take 80% of the data for the training set
data_test <- data[-sub,] # Take the remaining 20% for the testing set
dim(data_train) # Dimensions of the training set
dim(data_test)  # Dimensions of the testing set

#-----------------------------------------------------------------2- Cubist model parameter optimization----------------------------------------------------------------
library(caret)
set.seed(1)
ctrl <- trainControl(
  method = "cv",
  number = 10
)
tuneGrid <- expand.grid(
  # Committees: Non-negative integer (not more than 100) representing the number of committee members.
  committees = seq(10, 100, 10),
  # Neighbors: An integer between 0 and 9 representing the number of training instances used to adjust the model-based predictions.
  neighbors = c(0, 1, 3, 5, 7, 9)
)

model2 <- train(
  GCV ~ .,
  # Use SET1 for training
  # data = data_train[,c(1,2,4,10)],
  # Use SET2 for training
  data = data_train[,c(6,8,9,10)],
  # Use SET3 for training
  # data = data_train[,c(1,2,4,5,6,9,10)],
  method = 'cubist',
  preProcess = c("center", "scale"),
  trControl = ctrl,
  tuneGrid = tuneGrid,
  metric = "RMSE"
  #metric = "MAE"
  #metric = "Rsquared"
)
model2
plot(model2, metric = "MAE", pch = model2$results$neighbors) # MAE can be replaced with "RMSE", "Rsquared"

#----------------------------------------------------3- Cubist prediction--------------------------------------------------------------
library(Cubist)
# Create a Cubist model using SET1
# model_tree1 <- cubist(x = data_train[,c(1,2,4)], y = data_train$GCV, committees = 100)
# Create a Cubist model using SET2
model_tree2 <- cubist(x = data_train[,c(6,8,9)], y = data_train$GCV, committees = 100)
# Create a Cubist model using SET3
# model_tree3 <- cubist(x = data_train[,c(1,2,3,4,5,6)], y = data_train$GCV, committees = 100)

summary(model_tree2)

# Predict using model_tree1 with SET1 test data and 0 neighbors
# model_tree_pred1 <- predict(model_tree1, data_test[,c(1,2,4)], neighbors = 0)

# Predict using model_tree2 with SET2 test data and 9 neighbors
model_tree_pred2 <- predict(model_tree2, data_test[,c(6,8,9)], neighbors = 9)

# Predict using model_tree3 with SET3 test data and 0 neighbors
# model_tree_pred3 <- predict(model_tree3, data_test[,c(1,2,4,5,6,9)], neighbors = 0)

#d1_tree = data_test$GCV- model_tree_pred1
d2_tree = data_test$GCV- model_tree_pred2
#d3_tree = data_test$GCV- model_tree_pred3

#d=d1_tree
d=d2_tree
#d=d3_tree

# Calculate and print evaluation metrics
mse = mean((d)^2)
mae = mean(abs(d))
rmse = sqrt(mse)
R2 = 1-(sum((d)^2)/sum((data_test$GCV-mean(data_test$GCV))^2))
AARD <- mean(abs(d / data_test$GCV)) * 100
cat(" MAE:", mae, "\n", "MSE:", mse, "\n", 
    "RMSE:", rmse, "\n", "R-squared:", R2, "\n","AARD%:", AARD)
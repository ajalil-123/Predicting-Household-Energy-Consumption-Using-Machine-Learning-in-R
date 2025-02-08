install.packages("ranger")

# Load necessary libraries
library(dplyr)     
library(lubridate) 
library(ranger)    
library(xgboost)   
library(ggplot2)   

# Read training and testing data from CSV files
df_test <- read.csv("C:\\Users\\Abdul\\Desktop\\Data-Portfolio-Projects\\Predicting Energy Consumption using R\\df_test.csv")

df_train <- read.csv("C:\\Users\\Abdul\\Desktop\\Data-Portfolio-Projects\\Predicting Energy Consumption using R\\df_train.csv")

# Display structure of the training data
glimpse(df_train)

# Convert 'date' column to Date type and 'day_in_week' column to factor in both datasets
df_train <- df_train %>%
  mutate(date = as.Date(date, format = "%m/%d/%Y"),
         day_in_week = factor(day_in_week)) 
df_test <- df_test %>%
  mutate(date = as.Date(date, format = "%m/%d/%Y"),
         day_in_week = factor(day_in_week))

# Convert categorical variable 'day_in_week' to indicator variables using one-hot encoding in both datasets
df_onehot_train <- model.matrix(~ day_in_week - 1, data = df_train) %>%
  as.data.frame()
df_onehot_test <- model.matrix(~ day_in_week - 1, data = df_test) %>%
  as.data.frame()

# Combine one-hot encoded columns with the original datasets and remove the 'day_in_week' column
df_train <- mutate(df_train, df_onehot_train) %>% select(-c(day_in_week))
df_test <- mutate(df_test, df_onehot_test) %>% select(-c(day_in_week))

# Separate features and target variable for both training and testing datasets
train_x <- df_train %>% select(-power_consumption, -date)  
train_y <- df_train[["power_consumption"]]  
test_x <- df_test %>% select(-power_consumption, -date)  
test_y <- df_test[["power_consumption"]]  

# Train models, predict on test dataset and calculate RMSE for each model.
## Linear regression
lm_model <- lm(train_y ~ ., data = train_x)   
lm_pred <- predict(lm_model, newdata = test_x)  
lm_rmse <- sqrt(mean((test_y - lm_pred)^2))  

## Random forest
rf_model <- ranger(power_consumption ~., data = df_train %>% select(-date), num.trees = 1000)
rf_pred <- predict(rf_model, data = df_test %>% select(-date))$predictions  
rf_rmse <- sqrt(mean((test_y - rf_pred)^2))  

## XGBoost
xgb_model <- xgboost(
  data = as.matrix(train_x),  
  label = train_y,  
  nrounds = 500, 
  objective = "reg:squarederror",  
  eta = 0.1,  
  max_depth = 1,  
  verbose = FALSE
)
xgb_pred <- predict(xgb_model, newdata = as.matrix(test_x))  
xgb_rmse <- sqrt(mean((test_y - xgb_pred)^2))  

# RMSE scores
data.frame(
  Model = c("Linear Regression", "Random Forest", "XGBoost"),  
  RMSE = c(lm_rmse, rf_rmse, xgb_rmse)  
)

# Get the lowest RMSE and assign it to selected_rmse
selected_rmse <- min(lm_rmse, rf_rmse, xgb_rmse)
cat("selected_rmse:", selected_rmse, "kW\n")

# Add predictions to the test dataset for plotting
#df_test <- df_test %>%
#  mutate(Predicted = rf_pred)


# Calculate R-squared for each model
lm_r2 <- cor(lm_pred, test_y)^2
rf_r2 <- cor(rf_pred, test_y)^2
xgb_r2 <- cor(xgb_pred, test_y)^2

# Print R-squared values
cat("Linear Regression R-squared:", lm_r2, "\n")
cat("Random Forest R-squared:", rf_r2, "\n")
cat("XGBoost R-squared:", xgb_r2, "\n")


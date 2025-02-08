# Predicting Household Energy Consumption Using Machine Learning in R

## Dataset Description
The dataset consists of electric power consumption measurements from a single household, recorded at a one-minute sampling rate over nearly four years. It includes various electrical quantities and sub-metering values.

## Objective
The primary objective of this project was to develop and experiment with multiple machine learning models in R to determine the most effective approach for predicting daily household energy consumption. An accurate predictive model can assist energy providers in optimizing energy distribution and offering tailored recommendations to customers, contributing to sustainable energy usage while balancing energy demand and generation.

## Activities Performed
- **Data Cleaning and Pre-processing:** Ensured data quality by handling missing values and normalizing data.
- **Data Splitting:** Prepared training and testing datasets for model evaluation.
- **Model Training and Prediction:** Trained various machine learning models and tested their performance on unseen data.
- **Performance Evaluation:** Calculated and compared the Root Mean Squared Error (RMSE) of different models.

## Results
The following models were evaluated:

- **Linear Regression**
  - RMSE: **504.29**
- **Random Forest**
  - RMSE: **391.54**
- **XGBoost**
  - RMSE: **403.55**

## Conclusion
The best-performing supervised regression model for predicting daily household energy consumption is **Random Forest**, as it achieved the lowest RMSE value of **391.54**.


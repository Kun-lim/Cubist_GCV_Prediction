# Estimation of gross calorific value of coal based on the cubist regression model
This program is designed for predicting coal's Gross Calorific Value (GCV).
Thess python and R codes are accompanied by the article "Estimation of gross calorific value of coal based on the cubist regression model". 
We have made the necessary comments, please refer to the article for detailed implementation.

## Introduction
### 1 [select_cubist_model_perimeters.r]
Uses grid search to determine two parameters of the cubist algorithm: committees and neighbors (instances)
### 2[PSO-ANN Parameter Optimization.ipynb]
Tuning the parameters of a Multi-Layer Perceptron (MLP) neural network using Particle Swarm Optimization (PSO), and evaluates its performance on the task of GCV prediction.
### 3[Multiple Regression Model Comparison.ipynb]
(1) Calculation of Descriptive Statistics for the data.

(2) Boxplot for each variable.

(3)Scatter Plot Visualization: Generate scatter plots to explore the relationships between individual coal quality indicators and the GCV.

(4) Correlation Analysis: Compute the correlation coefficients and construct a heatmap to represent these correlations visually.

(5) Data Preprocessing for Regression: Prepare the data for regression analysis models.

(6) Training and prediction using 7 different regression analysis models.

(7) Computation of error metrics for the regression analyses.

(8) Error Metrics Visualization.
## Data Description
The data being read from <coal_all.csv> contains 10 variables：
(Moisture, Volatile_matter, Fixed_Carbon, Ash, Hydrogen, Carbon, Nitrogen, Oxygen, Sulfur, GCV)

Three sets of data (SET1, SET2, SET3) have been constructed based on different input variables.

SET1 (Moisture, Volatile_matter, Ash, GCV)

SET2 (Carbon, Oxygen, Sulfur, GCV)

SET3 (Moisture, Volatile_matter, Ash, Hydrogen, Carbon, Oxygen, Sulfur, GCV)

**Email**:heyuli301@126.com; chenjunlin@111.com

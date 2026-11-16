# Pune Real Estate Price Prediction System

## Project Overview
The Pune Real Estate Price Prediction System is a machine learning-based application developed using R. It estimates residential property prices in Pune based on property characteristics such as location, number of bedrooms, total area, bathrooms and balconies.

The project combines data preprocessing, exploratory data analysis, machine learning algorithms and an interactive Shiny dashboard to help users understand property prices.

## Objectives
- Analyse residential property data from Pune.
- Clean and preprocess real estate datasets.
- Identify factors influencing property prices.
- Train and compare multiple machine learning algorithms.
- Predict property prices based on user inputs.
- Develop an interactive dashboard for property price estimation.

## Technologies Used
- **Programming Language:** R
- **IDE:** RStudio
- **Dashboard:** Shiny, shinydashboard
- **Data Manipulation:** dplyr
- **Visualization:** ggplot2
- **Machine Learning:** Linear Regression, Decision Tree, Support Vector Machine (SVM), Random Forest

## Dataset Features
The dataset includes:
- Location
- Property size (BHK)
- Total area (square feet)
- Number of bathrooms
- Number of balconies
- Property price

## Data Preprocessing
The project includes:
- Handling missing values
- Converting property area into numerical values
- Removing invalid records
- Removing price-per-square-foot outliers
- Cleaning location information
- Preparing data for machine learning

## Machine Learning Models

Four algorithms were trained and evaluated:

1. Linear Regression
2. Decision Tree
3. Support Vector Machine (SVM)
4. Random Forest

## Model Performance

| Model | RMSE | MAE | R² |
|---|---:|---:|---:|
| Linear Regression | 27.35324 | 18.70738 | 0.85485 |
| Decision Tree | 47.98338 | 20.70661 | 0.55335 |
| SVM | 52.42632 | 19.79692 | 0.46680 |
| Random Forest | 42.06046 | 18.14008 | 0.65681 |

### Best Performing Model
Linear Regression achieved the lowest RMSE and highest R² score among the four evaluated models.

Random Forest achieved the lowest MAE.

## Application Features

The interactive Shiny dashboard includes:

### 1. Overview
- Total properties analysed
- Average property price
- Average property area
- Property price distribution
- Top 10 locations by average price

### 2. Predict Property Price
Users can enter:
- Property location
- Number of BHK
- Total area
- Bathrooms
- Balconies

The application generates an estimated property price.

### 3. Model Performance
- Model comparison table
- R-squared comparison
- RMSE comparison
- Best-performing algorithm

### 4. Prediction History
- Displays previous predictions during the current session
- Allows users to clear prediction history

## Project Structure

```text
Real-Estate-Price-Prediction/
│
├── House_price_prediction_system.R
├── app.R
├── punehouseprediction.csv
├── pune_cleaned_data.csv
├── house_price_model_bundle.rds
├── README.md
│
└── reports/
    ├── model_comparison.csv
    ├── model_comparison.png
    └── dashboard.png
```

## How to Run the Project

1. Install R and RStudio.
2. Download or clone this repository.
3. Open the RStudio project.
4. Set the project directory as the working directory.
5. Install the required packages:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "dplyr",
  "ggplot2",
  "caret",
  "e1071",
  "rpart",
  "randomForest"
))
```

6. Ensure the trained model bundle and dataset files are available.
7. Open `app.R`.
8. Click **Run App**.

## Applications
- Residential property price estimation
- Real estate market analysis
- Property comparison
- Preliminary property investment research

## Limitations
- Predictions are based on historical dataset information.
- The application does not use live property listings.
- Actual market prices may vary depending on market conditions and other factors.
- Prediction history is currently session-based.

## Future Enhancements
- Integration with live real estate datasets.
- Interactive property location maps.
- More advanced machine learning models.
- Permanent prediction history storage.
- Deployment as a publicly accessible web application.

## Disclaimer
This application provides estimated property prices for educational and analytical purposes. It should not be treated as a professional property valuation.

## Author
Developed as a Machine Learning project using R and Shiny.

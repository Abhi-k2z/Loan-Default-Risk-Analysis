# Loan-Default-Risk-Analysis
Loan default risk analysis using MySQL, Python (Google Colab) and Power BI

Case Study 4 (Banking & Finance) using the Credit Risk Dataset from Kaggle.

## Objective
Predict loan default risk, improve the loan approval strategy and reduce NPAs.

## Tools
- MySQL: data cleaning and analysis
- Python (Google Colab): classification models and feature importance
- Power BI: five dashboards

## Files
- `sql/loan_risk_analysis.sql`: MySQL script
- `python/loan_default_model.ipynb`: Python notebook
- `powerbi/loan_risk_dashboard.pbix`: Power BI dashboards
- `Case_Study_4_Loan_Default_Risk_Analysis.pdf`: full report

## Key results
- 32,409 loans after cleaning; overall default rate 21.87%
- Random Forest model: ROC-AUC 0.93
- The High Risk tier (24% of customers) holds 76% of defaults and 80% of the NPA amount
- Loan size relative to income, income, interest rate, loan grade and renting are the strongest default indicators

## Note
The branch field in the dashboards is simulated, because the dataset has no branch information.

Dataset: https://www.kaggle.com/datasets/laotse/credit-risk-dataset

Author: Abhishek Mahto

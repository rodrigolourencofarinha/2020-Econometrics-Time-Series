# Econometric Analysis: VAR and VEC Models on Time Series Data

This repository contains an applied econometric analysis of marketing mix variables using Vector Autoregressive (VAR) and Vector Error Correction (VEC) models. The analysis focuses on product sales, price, and product category volume (PCV) within the Brazilian cookie market, leveraging the Nielsen dataset. The goal of the analysis is to investigate how these marketing mix variables affect brand sales over time.

Note: This paper was never intended for publication; it was completed as part of the final assignment for an Advanced Econometrics course at the São Paulo School of Economics, Getulio Vargas Foundation. I'm sharing this in hope to help other students.

## Project Overview

- **Objective**: Analyze the relationship between sales, price, and PCV using time series econometric methods.
- **Methods**: We applied VAR and VEC models to capture the dynamic interactions between variables and test for cointegration.
- **Dataset**: Nielsen dataset from the Brazilian cookie category.

## Files

- **`src/analysis.R`**: Main R script containing all data processing, model estimation, and robustness tests.
- **`notebooks/2020-09-30_Econometrics_Applied_Paper.Rmd`**: This is an RMarkdown file used to generate the analysis with interpretation of results.
- **`2020_Applied_Paper_Marketing_Mix_Effectiveness_In-Store_Consumer_Market.pdf`**: This file contains the final written report.
- **`2020_Presentation_Marketing_Mix_Effectiveness_In-Store_Consumer_Market.pdf`**: This PDF contains the presentation slides used to summarize the findings of the applied paper.
- **`README.md`**: This document explaining the project and structure of the repository.

## Main Steps in the Analysis

1. **Data Import and Preprocessing**:
   - Load the Nielsen dataset.
   - Convert the data into time series format for analysis.

2. **Unit Root Testing**:
   - Perform Augmented Dickey-Fuller (ADF) tests to check the stationarity of the time series data.

3. **Linear Regression**:
   - Run a basic linear regression of sales on price and PCV to establish baseline relationships.
   - Extract the residuals for further analysis.

4. **VAR Model**:
   - Select the optimal lag for the VAR model using information criteria.
   - Estimate a VAR model to capture the short-term dynamics between sales, price, and PCV.
   - Perform robustness tests for serial correlation, heteroscedasticity, and normality of residuals.

5. **VEC Model**:
   - Conduct Johansen's cointegration test to assess long-term relationships between variables.
   - Estimate a VEC model to capture both short- and long-term dynamics.
   - Perform robustness tests for the VEC model.

6. **Granger Causality and Impulse Response**:
   - Perform Granger-causality tests to determine causal relationships between variables.
   - Plot impulse response functions to visualize the effect of shocks to one variable on another.

## Requirements

To replicate the analysis, you'll need the following R packages:
```r
install.packages(c('AER', 'tseries', 'urca', 'dlm', 'openxlsx', 'xts', 
                   'class', 'zoo', 'fBasics', 'qrmtools', 'stats', 
                   'MTS', 'vars', 'graphics', 'readxl', 'tsDyn', 'tidyverse'))
```

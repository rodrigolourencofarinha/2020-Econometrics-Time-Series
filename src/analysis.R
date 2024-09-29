# Load necessary packages
load_package <- function(x){
  x <- as.character(match.call()[[2]])
  if (!require(x, character.only=TRUE)){
    install.packages(pkgs=x, repos="http://cran.r-project.org")
    require(x, character.only=TRUE)
  }
}

# Loading required libraries
packages <- c('AER', 'tseries', 'urca', 'dlm', 'openxlsx', 'xts', 'class', 
              'zoo', 'fBasics', 'qrmtools', 'stats', 'MTS', 'vars', 
              'graphics', 'readxl', 'tsDyn', 'tidyverse')

lapply(packages, load_package)

# Import the data
Bauducco_r <- read_xlsx("Bauducco_r.xlsx")

# Convert data to time series
SALES <- ts(Bauducco_r$Sales, start = c(2012, 07), end = c(2015, 12), frequency = 12)
PRICE <- ts(Bauducco_r$Price, start = c(2012, 07), end = c(2015, 12), frequency = 12)
PCV <- ts(Bauducco_r$PCV, start = c(2012, 07), end = c(2015, 12), frequency = 12)

# Plot the series
plot(cbind(SALES, PRICE, PCV), main = "Time Series Plot: Sales, Price, and PCV")

# Augmented Dickey-Fuller (ADF) test for unit root
cat("ADF test for Sales: \n")
print(adf.test(SALES))

cat("ADF test for Price: \n")
print(adf.test(PRICE))

cat("ADF test for PCV: \n")
print(adf.test(PCV))

# Differencing the series
cat("ADF test for differenced Sales: \n")
print(adf.test(diff(SALES)))

cat("ADF test for differenced Price: \n")
print(adf.test(diff(diff(PRICE))))

cat("ADF test for differenced PCV: \n")
print(adf.test(diff(PCV)))

# Running linear regression
regressao <- lm(SALES ~ PRICE + PCV)
summary(regressao)

# Residuals from the regression (Equilibrium correction)
EqCM <- resid(regressao)

# Plot residuals (equilibrium correction)
plot(EqCM, type='l', col='steelblue', xlab = "Months", main = "Equilibrium Correction")

# ACF and PACF of the residuals
par(mfrow=c(1,2))
acf(EqCM)
pacf(EqCM)

# ADF test on residuals
cat("ADF test for residuals: \n")
print(adf.test(EqCM))

# Differencing the series for VAR model
SALES_DIF1 <- diff(SALES)
PRICE_DIF2 <- diff(diff(PRICE))
PCV_DIF1 <- diff(PCV)

# Combine data into a matrix
data <- cbind(SALES_DIF1, PRICE_DIF2, PCV_DIF1)
colnames(data) <- c("SALES", "PRICE", "PCV")
data <- na.omit(data)

# Selecting the optimal lag for VAR
VARselect(data, lag.max = 20, type = "const")

# Fitting the VAR model with 7 lags
VAR_model <- VAR(data, p = 7, type = "const")
summary(VAR_model)

# Plot VAR model results
plot(VAR_model)

# Conduct robustness tests
cat("Serial correlation test: \n")
print(serial.test(VAR_model, lags.pt = 6, type = "PT.asymptotic"))

cat("Heteroscedasticity test: \n")
arch_test <- arch.test(VAR_model)
print(arch_test$arch.mul)

cat("Normality test for residuals: \n")
normality_test <- normality.test(VAR_model, multivariate.only = TRUE)
print(normality_test)

# Plot stability test (CUSUM)
stability_test <- stability(VAR_model, type = "OLS-CUSUM")
plot(stability_test)

# Cointegration test for VEC model
vec_trace <- ca.jo(log(Bauducco_r), ecdet = "const", type = "trace")
vec_eigen <- ca.jo(log(Bauducco_r), ecdet = "const", type = "eigen")
summary(vec_trace)
summary(vec_eigen)

# Estimate VECM(6) with two cointegrating vectors
vec_model <- VECM(log(Bauducco_r), lag = 6, r = 2, estim = "ML", include = "none")
summary(vec_model)

# Robustness tests for VEC model
cat("Serial correlation test for VEC: \n")
serial_test_vec <- serial.test(vec2var(vec_trace), lags.pt = 6, type = "PT.asymptotic")
print(serial_test_vec)

cat("Heteroscedasticity test for VEC: \n")
arch_test_vec <- arch.test(vec2var(vec_trace))
print(arch_test_vec$arch.mul)

cat("Normality test for VEC residuals: \n")
normality_test_vec <- normality.test(vec2var(vec_trace), multivariate.only = TRUE)
print(normality_test_vec)

# Granger-causality test
cat("Granger-causality tests: \n")
print(grangertest(SALES ~ PRICE, order = 7))
print(grangertest(SALES ~ PCV, order = 7))
print(grangertest(PRICE ~ SALES, order = 7))
print(grangertest(PRICE ~ PCV, order = 7))
print(grangertest(PCV ~ SALES, order = 7))
print(grangertest(PCV ~ PRICE, order = 7))

# Impulse Response Function (IRF)
irf_sales <- irf(VAR_model, impulse = "PCV", response = "SALES", n.ahead = 40, boot = TRUE)
plot(irf_sales, ylab = "Sales", main = "Impulse Response from PCV to Sales")

# Forecast Error Variance Decomposition (FEVD)
vardec <- fevd(VAR_model, n.ahead = 10)
plot(vardec)

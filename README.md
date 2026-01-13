# real-estate-quantile-regression
Quantile regression analysis of real estate prices in Poland using R and Stata

# Real Estate Price Analysis using Quantile Regression

Econometric analysis of real estate prices using quantile regression to capture heterogeneous effects across the price distribution. Project for Advanced Econometrics II course at University of Warsaw.

## Overview

This project applies **quantile regression** to model apartment prices in Poland, examining how property characteristics affect prices differently across the price distribution (cheap vs. expensive apartments).

**Key advantage**: Unlike OLS regression which estimates average effects, quantile regression reveals how factors like size or location impact low-priced vs. high-priced properties differently.

## Data

**Dataset**: Real estate transactions in Poland  
**Variables**:
- **Dependent**: `ln_cena` (log of price)
- **Continuous**: `metraz` (square meters), `liczba_pokoi` (rooms), `pietro` (floor), `wiek_zabudowy` (building age), `odl_centrum` (distance to center)
- **Binary**: `parking`, `winda` (elevator), `balkon` (balcony), `ochrona` (security), `komorka_lokatorska` (storage), `kamienica` (tenement house), `apartamentowiec` (apartment building)
- **City size**: `male_miasto`, `srednie_miasto` (small/medium city dummies)

## Methodology

### 1. OLS Regression (Baseline)

Standard linear regression:
```
ln(price) = β₀ + β₁·size + β₂·rooms + ... + ε
```

**Diagnostic tests**:
- **Jarque-Bera test**: Test for normality of residuals
- **Breusch-Pagan test**: Test for heteroskedasticity
- **White test**: Alternative heteroskedasticity test

### 2. Quantile Regression

Estimated at quantiles: **τ ∈ {0.05, 0.10, 0.25, 0.50, 0.75, 0.90, 0.95}**

**Model**:
```
Q_τ(ln(price)|X) = β₀(τ) + β₁(τ)·size + β₂(τ)·rooms + ...
```

where Q_τ denotes the τ-th conditional quantile.

**Key feature**: Coefficients β(τ) vary across quantiles, revealing heterogeneous effects.

### 3. Bootstrap Standard Errors

- **Method**: Bootstrap with 200 replications for robust inference
- **Implementation**: `bsqreg` and `sqreg` commands in Stata, `quantreg` package in R

### 4. Visualization

- Coefficient plots across quantiles with confidence intervals
- Comparison of OLS (horizontal line) vs. quantile regression coefficients
- Individual plots for each variable showing effect heterogeneity

## Key Findings (Typical Patterns)

**Size (metraz)**:
- Larger effect on expensive apartments (upper quantiles)
- Market values extra square meters more in luxury segment

**Building age (wiek_zabudowy)**:
- Stronger negative effect on expensive properties
- Buyers of luxury apartments more sensitive to building age

**Elevator (winda)**:
- Stronger positive effect on expensive apartments
- Premium feature valued more in high-end market

**Distance to center (odl_centrum)**:
- Effect varies across distribution
- Location matters more for certain price segments

## Implementation

### R Code
```r
library(quantreg)
library(readxl)

# Load data
data <- read_excel("nieruchomosci.xlsx")
data <- na.omit(data)

# Log transformation
data$cena_log <- log(data$cena)

# OLS regression
ols <- lm(cena_log ~ metraz + liczba_pokoi + ..., data = data)

# Quantile regression
qr_50 <- rq(cena_log ~ metraz + liczba_pokoi + ..., 
            tau = 0.50, data = data)
```

### Stata Code
```stata
* Log transformation
gen ln_cena = log(cena)

* OLS regression
regress ln_cena metraz liczba_pokoi ...

* Quantile regression with bootstrap
sqreg ln_cena metraz liczba_pokoi ..., ///
    quantile(0.05 0.1 0.25 0.5 0.75 0.9 0.95) reps(200)

* Graphical presentation
grqreg, cons ols ci olsci reps(20)
```

## Tools

- **Stata**: Primary analysis platform (`bsqreg`, `sqreg`, `grqreg`)
- **R**: Alternative implementation with `quantreg` package
- **Packages**: `lmtest`, `car`, `tseries` for diagnostic tests

## Files

- `regresja_kwantylowa.do` - Stata analysis script
- `regresja_kwantylowa.R` - R implementation
- `nieruchomosci.xlsx` - Real estate dataset (not included for privacy)

## Applications

- **Policy**: Understanding housing affordability across price segments
- **Real estate valuation**: More accurate pricing models
- **Market analysis**: Identifying factors driving luxury vs. affordable housing
- **Investment**: Targeting specific market segments

---

**Course**: Advanced Econometrics II (Zaawansowana Ekonometria 2)  

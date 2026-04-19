# Market-Microstructure-Structural-Breaks-Analyzing-the-2026-Black-Swan
An Econometric Study of FPI Reactivity and DII Absorption during the US-Iran Conflict
## Executive Summary
This project investigates the impact of the February 2026 US-Iran conflict on the Indian Equity Market (NIFTY 50). Using advanced econometrics, I challenge the common narrative that Foreign Portfolio Investors (FPIs) lead market movements.

## Key Finding
FPIs are reactive participants. They demonstrated a 1-to-3 day lag in response to market shocks, while Domestic Institutional Investors (DIIs) acted as a critical liquidity cushion through "Absorption."

## Methodology & Technical Stack
### Language: R (tidyverse, lmtest, lmreg, zoo, rugarch, ggplot2)
### Statistical Tests: Augmented Dickey-Fuller (Stationarity), Granger Causality (Directionality), GARCH 1,1 (Volatility Persistence).
### Event Study: Cumulative Abnormal Returns (CAR) using Log-Returns to quantify idiosyncratic wealth destruction.

## Key insights & Visualizations
### The "Correlation Flip" (Regime Shift) 
Prior to the conflict, the correlation between FPI flows and NIFTY returns was near-zero. Post-war, it plunged to -0.385. This "dive" signifies a structural break where traditional macro links dissolved into exogenous panic.
### The Lead-lag Paradox : Granger causality. 
Hypothesis : Does FPI Lead NIFTY?

Lag 2 Days (p=0.131). Insignificant. FPIs do not predict the market.


Hypothesis : Does NIFTY Lead FPI?

Lag 1 Day (p<0.001). Highly Significant. FPIs follow market signals.

### Wealth Destruction (Event Study)
The CAR plot demonstrates a sustained erosion of market value. By filtering out "Expected Returns" (Pre-War Mean), I isolated the over 10% idiosyncratic loss attributed specifically to the geopolitical shock.

### Volatility Clustering (GARCH 1,1)
The GARCH model proves that risk doubled from 0.008 to 0.016. This sustained elevation in conditional volatility triggered institutional Value-at-Risk (VaR) thresholds, forcing the reactive selling observed in the data


The GARCH model proves that risk doubled from 0.008 to 0.016. This sustained elevation in conditional volatility triggered institutional Value-at-Risk (VaR) thresholds, forcing the reactive selling observed in the data.

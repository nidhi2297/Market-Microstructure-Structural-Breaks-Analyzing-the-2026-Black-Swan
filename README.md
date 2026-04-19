# Market-Microstructure-Structural-Breaks-Analyzing-the-2026-Black-Swan
An Econometric Study of FPI Reactivity and DII Absorption during the US-Iran Conflict
## Executive Summary
This project investigates the impact of the February 2026 US-Iran conflict on the Indian Equity Market (NIFTY 50). Using advanced econometrics, I challenge the common narrative that Foreign Portfolio Investors (FPIs) lead market movements.

•	The Conflict: The US-Iran war triggered a massive structural break in the Indian market.

•	The Myth: Contrary to popular belief, FPIs did not lead the crash.

•	The Reality: FPIs were reactive, selling with a 1-to-3 day lag after the NIFTY already dropped.

•	The Stabilizer: DIIs (Domestic Institutional Investors) absorbed the selling pressure, preventing a total collapse.

•	The Risk: Volatility (GARCH 1,1) doubled post-war, indicating a long-term "Uncertainty Premium" in the market.


## Key Finding
FPIs are reactive participants. They demonstrated a 1-to-3 day lag in response to market shocks, while Domestic Institutional Investors (DIIs) acted as a critical liquidity cushion through "Absorption."

## Data Collection & Cleaning

•	Sources: NSE, GR0WW

•	Frequency: Daily data for one year.

•	Cleaning: Handling missing values, aligning dates, merging datasets.

•	Transformation: Created returns for NIFTY, Brent Oil and USD/INR rate. No transformation for FPI flows. 

•	Scaling: Standardization of data for visualisation.


## Methodology & Technical Stack

•	Dataset: Compiled data on NIFTY_50, Net FPI flows to India, Brent Oil Futures, and USD/INR exchange rate for the FY 2025-26.

•	Language: R (tidyverse, lmtest, lmreg, zoo, rugarch, ggplot2)

•	Statistical Tests: Augmented Dickey-Fuller (Stationarity), Granger Causality (Directionality), GARCH 1,1 (Volatility Persistence).

•	Event Study: Cumulative Abnormal Returns (CAR) using Log-Returns to quantify idiosyncratic wealth destruction.

## Exploratory Analysis

### Plotting time series of each variable visualising their co-movements and the impact of war.
#### FPI flows over time
<p align="center">
  <img src="FPI Flows and War Shock.png" width="48%" />
  <img src="FPI Box plot.png" width="48%" />
</p>

In the post war period, there is a clear declining trend. The volatility also reduced post war indicating a constant selling pressure.

#### FPI vs Oil Movement
c

A clear spike Brent Oil and fall in the FPIs post war. Oil became more volatile in post-war energy shock. 
#### FPI vs USD/INR Movement
<p align="center">
  <img src="FPI vs INR.png" width="84%" />
</p>

It is evident from the plot that the USD_INR appreciated visibly post war (seen by the purple line in the line chart), while the FPI follows the downward trend post war. INR_z ↑ (currency weakening) and FPI_z ↓ (outflows increasing). This shows capital flight in the wake of rising geopolitical tensions.

#### FPI vs NIFTY Movement
<p align="center">
  <img src="FPI vs NIFTY.png" width="48%" />
  <img src="FPI vs NIFTY zoom.png" width="48%" />
</p>

It is widely believed that FPIs determine Market returns. Our focus will be specifically on what this causality is and how it changes in the face of a Black Swan Event like US-Iran war that started on 28th February, 2026. We can clearly see that the volatility has increased considerably in NIFTY in the post war period. 

#### Master plot: Macro dynamics during the Black Swan event
<p align="center">
  <img src="Macro Dynamics.png" width="84%" />
</p>

• Volatility Clustering: The density of the spikes increases significantly after the red dashed line (Feb 2026).

•	Oil (Blue) and NIFTY → volatility spikes 

•	USD/INR (Purple) → depreciation pressure 

•	FPI (red) → sustained outflows 

## Regression Analysis
### MODEL 1 : MARKET RETURNS AS A FUNCTION OF FPI FLOWS, BRENT OIL AND USD/INR EXCHANGE RATES


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

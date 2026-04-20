# Market Microstructure Structural Breaks : Analyzing the 2026 Black Swan in context of FPI and Market Returns
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
### MODEL 1 : MARKET RETURNS AS A FUNCTION OF FPI FLOWS, BRENT OIL AND USD/INR RETURNS
While FPI flows show significant outflows during geopolitical stress, they do not explain daily market returns.**Instead, currency movements (USD/INR) - p val 0.0002 - emerge as a statistically significant driver of market performance.**

This relationship is stronger in the pre-war model with Adjusted R square close to 8%.
### MODEL 2 : FPI AS A FUNCTION OF NIFTY, BRENT OIL AND USD/INR RETURNS
While market returns respond significantly to currency movements, **FPI flows themselves are not well explained by daily macro or market variables.** This suggests that foreign investor behavior is driven by broader global factors, expectations, and sentiment rather than observable short-term indicators.

| Variable | Full Dataset (Total) | Pre-War (Peacetime) | Post-War (Black Swan) |
| :--- | :--- | :--- | :--- |
| **Intercept** | -562.1 (.) | -62.04 | **-7,940.0 (*)** |
| **NIFTY_Return** | 2,781.5 | -25,273.3 | -82,365.6 |
| **Oil_Return** | -10,040.4 | -6,789.7 | 2,572.8 |
| **INR_Return** | -128,539.8 | -136,569.2 | 176,525.6 |
| | | | |
| **Observations (N)** | 237 | 219 | **18** |
| **Adjusted R²** | 0.0003 | -0.0042 | **0.0387** |
| **F-Statistic** | 1.031 | 0.690 | 1.228 |

> **Key Insight:** The significance of the **Intercept** in the Post-War model ($p < 0.05$) represents the "Geopolitical Risk Premium." It indicates a baseline daily outflow of ~₹7,940 Cr triggered purely by the conflict, independent of market returns.

## Diving deep into FPI and NIFTY relationship.
### The Lead-lag Paradox : Granger causality. 
Hypothesis : Does FPI Lead NIFTY?

Lag 2 Days (p=0.131). Insignificant. FPIs do not predict the market.


Hypothesis : Does NIFTY Lead FPI?

Lag 1 Day (p<0.001). Highly Significant. FPIs follow market signals.

**Combined with the earlier 'Predictive Test' (where FPI failed to lead NIFTY), these findings provide empirical evidence that FPIs act as reactive participants in the Indian market.** 

### The "Correlation Flip" (Regime Shift) 
30 Day Rolling Correlation between FPI and NIFTY
<p align="center">
  <img src="Rolling Corr.png" width="84%" />
</p>

The 30-day Rolling Correlation plot highlights the dynamic nature of capital flow sensitivity. While the relationship is traditionally positive, we observe two significant 'Negative Dives':

1.	June 2025: Likely reflecting a tactical decoupling during the Import Tariff announcements.

2.	February 2026 Onward: A more severe dive coinciding with the US-Iran conflict.

The "Negative Dive" usually signals a Lead-Lag Mismatch or Absorption.

•	Scenario A (The Lag): The market crashes on Day 1. FPIs, being huge institutions with slow approval chains, sell on Day 2 and Day 3. If the market tries to bounce on Day 2/3 while FPIs are still dumping, you get a negative correlation.

•	Scenario B (The Absorption): Domestic Institutional Investors (DIIs) are "Buying the Dip." If DIIs buy more than what FPIs are selling, the NIFTY rises despite FPI outflows.

30 Day Rolling Correlation between FPI and NIFTY
<p align="center">
  <img src="DII absorption.png" width="84%" />
</p>

The Absorption effect is evident from the above DII data for the month of March, 2026

### Running lagged regression models in view of the above findings - Lead-Lag Analysis: Who Moves First?
The following table summarizes the results of the **Lagged Regression Models** ($\text{Lag-1}$), which isolate the chronological impact of variables.

| Predictor (Lag-1) | Dependent: **NIFTY_Return** | Dependent: **FPI_Net** |
| :--- | :--- | :--- |
| **NIFTY_Return** | — | **201,300 (***)** |
| **FPI_Net** | 0.0000001 (0.356) | — |
| **INR_Return** | **-0.449 (*)** | -179,800 (.) |
| **Oil_Return** | -0.0071 (0.731) | -1.633 (0.999) |
| | | |
| **Adjusted R²** | 0.0251 | **0.1446** |
| **F-Statistic** | 3.017 | **14.24 (***)** |

> **Finding:** The high Significance and R² in the **FPI_Net** model confirm that FPI flows are **Reactive**. Foreign institutions trade based on the previous day's market performance rather than leading the discovery of new prices.

### Wealth Destruction (Event Study)
The CAR plot demonstrates a sustained erosion of market value. By filtering out "Expected Returns" (Pre-War Mean), I isolated the over 10% idiosyncratic loss attributed specifically to the geopolitical shock.
<p align="center">
  <img src="CAR post-war.png" width="84%" />
</p>
Every time the line moves down, the market is "underperforming" its historical average. Every reduction by 0.01 means that from the start of the war to today, the NIFTY has lost 1% more value than it would have in a normal peacetime period.


### Volatility Clustering (GARCH 1,1)
We use GARCH when the variance is not constant. In simple terms, this means that "large changes tend to be followed by large changes, and small changes tend to be followed by small changes." It is the mathematical proof that the war didn't just cause a one-day drop—it shifted the entire market into a High-Risk Regime. 

<p align="center">
  <img src = "Volatility Clustering.png" width ="84%" />
</p>


| Feature | Observation from Plot | Financial Meaning |
| :--- | :--- | :--- |
| **Pre-War (Peacetime)** | Volatility was low and stable (roughly **0.008**). | The market was in a **Low-Volatility Regime** with predictable, stationary risks. |
| **The "War" Spike** | Sharp, vertical climb past the threshold (Feb 2026). | A **Structural Break** in risk. The market absorbed a massive exogenous geopolitical shock. |
| **Volatility Clustering** | High peaks followed by sustained high levels. | **Risk is "sticky."** High uncertainty led to a period of "Informed Panic" and jittery price discovery. |
| **Current Trend** | Volatility is at its peak (**> 0.016**). | The market hasn't "cooled down." Risk is currently **double** the peacetime average. |

> **Analyst Note:** The doubling of conditional volatility acts as a catalyst for institutional exits. Most FPI algorithms operate on **Value-at-Risk (VaR)** models; when the GARCH volatility spikes, these models trigger automatic sell orders, explaining the reactive flows proven in our Granger Causality test.
The GARCH model proves that risk doubled from 0.008 to 0.016. This sustained elevation in conditional volatility triggered institutional Value-at-Risk (VaR) thresholds, forcing the reactive selling observed in the data

## 📝 Limitations & Scope
* **Lag Structure:** While Lag-1 showed the highest significance, extreme volatility events may exhibit intra-day leads not captured by daily closing data.
* **Exogenous Factors:** The models focus on the US-Iran conflict; however, concurrent global inflation trends and domestic policy shifts may contribute to the 'Geopolitical Risk Premium' captured by the intercept.

## 👤 About the Author
**[Nidhi Sharma]** * Aspiring Quantitative Analyst | CFA Level 1 Candidate | ISI Alumnus*
## 📧 Contact & Connect
* **LinkedIn:** [Nidhi Sharma](www.linkedin.com/in/nidhi-sharma-290717129)
* **Portfolio:** [(https://github.com/nidhi2297/ILFS-Risk-Analysis)]

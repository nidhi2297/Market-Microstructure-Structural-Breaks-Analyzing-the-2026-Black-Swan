# LOADING REQUIRED PACKAGES
library(dplyr)
library(lubridate)
library(ggplot2)
library(stringr)
# IMPORTING DATA
FPI <- read.csv(file.choose())
head(FPI)
INR <-read.csv(file.choose())
head(INR)
OIL <-read.csv(file.choose())
head(OIL)
NIFTY <- read.csv(file.choose(), stringsAsFactors = FALSE)
str(NIFTY$Date)

# Inconsistency in NIFTY date format. Some values in dmy, some in mdy
# Fixing it
NIFTY <- NIFTY %>%
  mutate(
    Date = str_trim(Date),
    
# Try mdy first
    Date_mdy = suppressWarnings(mdy(Date)),
    
# Try dmy for remaining
    Date_dmy = suppressWarnings(dmy(Date)),
    
    # Combine: use mdy if available, else dmy
    Date = coalesce(Date_mdy, Date_dmy),
    
    NIFTY_50 = as.numeric(gsub(",", "", NIFTY_50))
  ) %>%
  select(Date, NIFTY_50) %>%
  arrange(Date)
summary(is.na(NIFTY$Date))
head(NIFTY)
tail(NIFTY)

# CLEANING THE OTHER DATASETS FOR SAME FORMAT
FPI <- FPI %>%
  rename(
    Date = Reporting.Date,
    FPI_Net = Net_FPI..Rs.Crore.
  ) %>%
  mutate(Date = dmy(Date)) %>%
  arrange(Date)

INR <- INR %>%
  mutate(Date = dmy(Date)) %>%
  arrange(Date)

OIL <- OIL %>%
  mutate(Date = dmy(Date)) %>%
  arrange(Date)
head(OIL)
head(INR)
head(FPI)

# MERGING ALL THE DATASETS, PERFORMING INNER JOIN
Dataset <- FPI %>%
  inner_join(NIFTY, by = "Date") %>%
  inner_join(INR, by = "Date") %>%
  inner_join(OIL, by = "Date")
nrow(Dataset)
head(Dataset)
summary(Dataset)

#CHECKING STATIONARITY USIND AUGMENTED DICKEY FULLER TEST
library(tseries)
# FPI flows series
adf.test(na.omit(Dataset$FPI_Net))
# p val = 0.1, FPI flows are stationary, no transformation required

# NIFTY_50
adf.test(na.omit(Dataset$NIFTY_50))
# p val = 0.976, Not stationary

# USD_INR
adf.test(na.omit(Dataset$USD_INR))
# p val = 0.17, Not Stationary

# Brent_OIL
adf.test(na.omit(Dataset$Brent_Oil))
# p val = 0.99, Not Stationary

# Creating returns to ensure stationarity

Dataset <- Dataset %>%
arrange(Date) %>%
mutate(
    NIFTY_Return = log(NIFTY_50/ lag(NIFTY_50)),
    Oil_Return = log(Brent_Oil / lag(Brent_Oil)),
    INR_Return = log(USD_INR / lag(USD_INR)))

# VISUALIZING TRENDS AND THE IMPACT OF WAR

ggplot(Dataset, aes(x = Date, y = FPI_Net)) +
  geom_line(color = "blue") +
  geom_vline(xintercept = as.Date("2026-02-28"),
             color = "red", linetype = "dashed") +
  labs(
    title = "Net FPI Flows and the War Shock (Feb 2026)",
    y = "Net FPI (Rs Crore)",
    x = "Date"
  ) +
  theme_minimal()

# BIFURCATING THE DATA INTO PRE AND POST WAR PERIOD 

Dataset <- Dataset %>%
  mutate(
    War = ifelse(Date >= as.Date("2026-02-28"), "Post-War-data", "Pre-War-data")
  )
# USING BOX PLOT FOR PRE AND POST WAR COMPARISON

ggplot(Dataset, aes(x = War, y = FPI_Net, fill = War)) +
  geom_boxplot() +
  labs(
    title = "FPI Flows: Pre vs Post War",
    y = "FPI Net (Rs Crore)"
  ) +
  theme_minimal()
# DESCRPITIVE STATS
Dataset %>%
  group_by(War) %>%
  summarise(
    avg_FPI = mean(FPI_Net),
    volatility_FPI = sd(FPI_Net)
  )
# SCALING THE VARIABLES TO VISUALISE THEIR RELATIONSHIPS 
library(dplyr)
Dataset <- Dataset %>%
  mutate(FPI_Z = scale(FPI_Net),
         NIFTY_Z = scale(NIFTY_Return),
         OIL_Z = scale(Oil_Return),
         INR_Z = scale(INR_Return))

# VISUALISING INTER-RELATIONSHIPS OF MACRO-VARIABLES
# FPI vs OIL
ggplot(Dataset, aes(x = Date)) +
  geom_line(aes(y = FPI_Z), color = "blue") +
  geom_line(aes(y = `OIL_Z <- scale(Oil_Return)`), color = "orange") +
  geom_vline(xintercept = as.Date("2026-02-28"),
             linetype = "dashed", color = "red") +
  labs(
    title = "Standardized FPI vs Oil Movements",
    y = "Z-score",
    subtitle = "Comparison of relative movements"
  ) +
  theme_minimal()
# ZOOMING IN
Dataset_war <- Dataset %>%
  filter(Date >= as.Date("2026-01-15"))

ggplot(Dataset_war, aes(x = Date)) +
  geom_line(aes(y = FPI_Z), color = "blue") +
  geom_line(aes(y = OIL_Z), color = "orange") +
  geom_vline(xintercept = as.Date("2026-02-28"),
             linetype = "dashed", color = "red") +
  labs(
    title = "Standardized FPI vs Oil Movements during War Period",
    subtitle = "Zoomed view for better clarity"
  ) +
  theme_minimal()

# FPI vs USD_INR MOVEMENT
ggplot(Dataset, aes(x = Date)) +
  geom_line(aes(y = FPI_Z), color = "blue") +
  geom_line(aes(y = INR_Z), color = "purple") +
  geom_vline(xintercept = as.Date("2026-02-28"),
             linetype = "dashed", color = "red") +
  labs(
    title = "Standardized FPI vs USD/INR Movement",
    y = "Z-score"
  ) +
  theme_minimal()

# FPI VS NIFTY
ggplot(Dataset, aes(x = Date)) +
  geom_line(aes(y = FPI_Z), color = "blue") +
  geom_line(aes(y = NIFTY_Z), color = "green") +
  labs(
    title = "Standardized FPI vs NIFTY Movement",
    y = "FPI & NIFTY Returns (scaled)"
  ) +
  theme_minimal()
# Zooming in
ggplot(Dataset_war, aes(x = Date)) +
  geom_line(aes(y = FPI_Z), color = "blue") +
  geom_line(aes(y = NIFTY_Z), color = "green") +
  geom_vline(xintercept = as.Date("2026-02-28"), 
             linetype = "dashed", color = "red")+
  labs(
    title = "Standardized FPI vs NIFTY Movements during War Period",
    subtitle = "Zoomed view for better clarity",
    y = "FPI & NIFTY Returns (scaled)"
  ) +
  theme_minimal()

# DESCRIPTIVE STATS ON FPI and NIFTY 
Dataset %>%
  group_by(War) %>%
  summarise(
    correlation = cor(FPI_Net, NIFTY_Return, use = "complete.obs"),
    avg_FPI = mean(FPI_Net),
    avg_NIFTY = mean(NIFTY_50),
    volatility_FPI = sd(FPI_Net),
    volatilit_NIFTY = sd(NIFTY_Return, na.rm = TRUE))

# THE MASTER MACRO PLOT
ggplot(Dataset, aes(x = Date)) +
  geom_line(aes(y = FPI_Z, color = "FPI")) +
  geom_line(aes(y = OIL_Z, color = "Oil")) +
  geom_line(aes(y = INR_Z, color = "USD/INR")) +
  geom_line(aes(y=NIFTY_Z, color ="NIFTY")) +
  geom_vline(xintercept = as.Date("2026-02-28"),
             linetype = "dashed", color = "red") +
  
  labs(
    title = "Macro Dynamics: FPI, NIFTY, Oil, and Currency Movements",
    y = "Standardized Values",
    color = "Variables"
  ) +
  theme_minimal()
# Zooming in for better clarity
ggplot(Dataset_war, aes(x = Date)) +
  geom_line(aes(y = FPI_Z, color = "FPI")) +
  geom_line(aes(y = OIL_Z, color = "Oil")) +
  geom_line(aes(y = INR_Z, color = "USD/INR")) +
  geom_line(aes(y=NIFTY_Z, color ="NIFTY")) +
  geom_vline(xintercept = as.Date("2026-02-28"),
             linetype = "dashed", color = "red") +
  
  labs(
    title = "Macro Dynamics: FPI, NIFTY, Oil, and Currency Movements",
    y = "Standardized Values",
    color = "Variables"
  ) +
  theme_minimal()

# REGRESSION ANALYSIS
# MODEL 1: MARKET RETURNS AS A FUNCTION OF FPI, USD_INR Rate and BRENT OIL RETURNS
library(lmreg)
MODEL1 <- lm(NIFTY_Return ~ FPI_Net + Oil_Return + INR_Return,
                data=Dataset)
summary(MODEL1)
# REGRESSION MODEL FOR PRE AND POST WAR DATA
Pre_War<- Dataset %>%
  filter(Date < as.Date("2026-02-28"))
Post_War<- Dataset %>%
  filter(Date >= as.Date("2026-02-28"))
MODEL1PR <-lm(NIFTY_Return ~ FPI_Net + Oil_Return + INR_Return,
              data = Pre_War )
summary(MODEL1PR)
MODEL1PST <-lm(NIFTY_Return ~ FPI_Net + Oil_Return + INR_Return,
              data = Post_War )
summary(MODEL1PST)
# USD_INR is the only significant driver of Market returns
# Post war model is not statistically robust due to limited observations
# From the above model, FPIs are not predictive of Market returns

# MODEL 2: FPI AS A FUNCTION OF MARKET RETURNS, USD_INR and BRENT OIL RETURNS
MODEL2 <-lm(FPI_Net ~ NIFTY_Return + Oil_Return + INR_Return,
            data=Dataset)
MODEL2PR <-lm(FPI_Net ~ NIFTY_Return + Oil_Return + INR_Return,
              data=Pre_War)
MODEL2PST <-lm(FPI_Net ~ NIFTY_Return + Oil_Return + INR_Return,
               data=Post_War)
summary(MODEL2)
summary(MODEL2PR)
summary(MODEL2PST)
# FPI are driven by broader range of factors and not daily movements in these macro variables


# RUNNING GRANGER'S CAUSALITY TEST TO DIVE DEEP INTO THESE FINDINGS

# Test 1: DO FPIs LEAD THE MARKET? (The "Predictive" Test)
# We'll check for a 2-day lag as a starting point
library(lmtest)
Granger_predictive <- grangertest(NIFTY_Return ~ FPI_Net, order = 2, data = Dataset)
print(Granger_predictive)
# p value = 0.1318 >0.05, FPI is not predictive

# Test 2: DO MARKET RETURNS LEAD FPI? (The "Reactive" Test)
Granger_reactive <- grangertest(FPI_Net ~ NIFTY_Return, order = 2, data = data)
print(Granger_reactive)
# p value < 0.001, hence they are reactive

# Checking if they react even faster (1 day) or slower (3 days)
grangertest(FPI_Net ~ NIFTY_Return, order = 1, data = data)
grangertest(FPI_Net ~ NIFTY_Return, order = 3, data = data)


# VISUALIZING THIS RELATIONSHIP 
# ROLLING CORRELATION BETWEEN NIFTY AND FPI 
library(zoo)
#Calculate 30-day rolling correlation between NIFTY and FPI
Dataset <- Dataset %>%
  mutate(
    roll_cor_FPI = rollapplyr(data.frame(NIFTY_Return, FPI_Net), 30, 
                              function(x) cor(x[,1], x[,2], use="complete.obs"), 
                              by.column=FALSE, fill=NA)
  )
library(ggplot2)
ggplot(Dataset, aes(x = Date, y = roll_cor_FPI)) +
  geom_line(color = "darkgreen") +
  geom_hline(yintercept = 0, linetype = "dotted") +
  geom_vline(xintercept = as.Date("2026-02-28"),
             linetype = "dashed", color="red")+
  labs(title = "30-Day Rolling Correlation: NIFTY vs FPI Flows",
       subtitle = "Note the sharp dive into negative territory during the war") +
  theme_minimal()

# SINCE WE HAVE A CLEAR EVIDENCE THAT FPIs REACT TO MARKET RETURNS WITH A LAG,
# HENCE SHOWING NEGATIVE CORRELATION, 
# THUS RUNNING A LAGGED REGRESSION MODEL

# CREATING LAGGED VARIABLES
Dataset <- Dataset %>%
  mutate(
    FPI_lag = lag(FPI_Net),
    Oil_lag = lag(Oil_Return),
    INR_lag = lag(INR_Return)
  )

LAGGEDM1 <-lm(NIFTY_Return ~ FPI_lag + Oil_lag +INR_lag,
              data = Dataset)
summary(LAGGEDM1)
# Currency was the only significant variable

Dataset<- Dataset%>%
  mutate(NIFTY_lag = lag(NIFTY_Return))

LAGGEDM2 <- lm(FPI_Net ~ NIFTY_lag + Oil_lag + INR_lag,
               data = Dataset)
summary(LAGGEDM2)
# NIFTY_lag is a significant driver of the FPIs. R squared showed considerable improvement
# over our previous model (without lag)

# MOVING ON TO EVENT STUDY: ABNORMAL RETURNS CAUSED BY THE WAR
Avg_Pre_War <-mean(Pre_War$NIFTY_Return, na.rm=TRUE)
# Abnormal returns during the war period
library(dplyr)
Post_War <-Post_War %>%
  mutate(Expected_Return = Avg_Pre_War, Abnormal_return = NIFTY_Return-Expected_Return,
         Cumulative_AR = cumsum(Abnormal_return))
# Visualizing the wealth destruction caused by war
library(ggplot2)
ggplot(Post_War, aes(x = Date, y = Cumulative_AR)) +
  geom_line(color = "red", size = 1) +
  geom_area(fill = "red", alpha = 0.2) +
  labs(title = "Cumulative Abnormal Returns (CAR) Post-War",
       subtitle = "Total market impact attributed specifically to the conflict",
       y = "CAR", x = "Date") +
  theme_minimal()

# Observing volatility clustering using GARCH
library(rugarch)
GARCH_spec<-ugarchspec(variance.model = list(model="sGARCH",
                                             garchOrder=c(1,1)),
                       mean.model=list(armaOrder=c(0,0)))
# Fitting model to NIFTY_Returns
Garch_fit<-ugarchfit(spec=GARCH_spec,
                      data=na.omit(Dataset$NIFTY_Return))
# Extracting and plotting volatility
# To visualise if Risk spiked during war
Dataset$Volatility<- NA
Dataset$Volatility[!is.na(Dataset$NIFTY_Return)] <- sigma(Garch_fit)

# Plotting volatility
library(ggplot2)
ggplot(Dataset, aes(x = Date, y = Volatility)) +
  geom_line(color = "darkblue") +
  geom_vline(xintercept = as.Date("2026-02-28"), linetype = "dashed", color = "red") +
  labs(title = "NIFTY Volatility (GARCH 1,1)",
       subtitle = "Visualizing how risk 'clustered' during the war event",
       y = "Conditional Volatility") +
  theme_minimal()


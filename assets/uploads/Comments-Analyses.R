# Set default working directory (modify to your own folder)
setwd('~/Dropbox/publication/2013/comment gmo')

# Load packages for graphics. They are freely
# available from CRAN
require(ggplot2)
require(scales)

# Reading FAO maize data
FAOcorn = read.csv('FAOcorn.csv')

# Extracting Area
FAOarea = subset(FAOcorn, Element == 'Area Harvested', 
                 select = c('Country', 'Year', 'Value'))

names(FAOarea)[3] = 'Area'

# and production
FAOprod = subset(FAOcorn, Element == 'Production', 
                 select = c('Country', 'Year', 'Value'))

names(FAOprod)[3] = 'Production'

# to calculate yield in hectograms
FAOarea = merge(FAOarea, FAOprod, by = c('Country', 'Year'))
FAOarea$Yield = with(FAOarea, Production/Area*10000)

FAOarticle = subset(FAOarea, Year <= 2010 & 
                    (Country == 'United States of America' | Country == 'Western Europe'))

# This matches Figure 1 in Heinemann et al.'s paper
ggplot(FAOarticle, aes(x = Year, y = Yield, color = Country)) + 
      geom_point() + stat_smooth(method = lm, fullrange = TRUE, alpha = 0.1) + 
      scale_y_continuous('Yield [hectograms/ha]', limits = c(0, 100000), labels = comma) + 
      theme(legend.position="top")


# Expressing year as a deviation from 1960, so results
# match paper
FAOarticle$NewYear = with(FAOarticle, Year - 1960)


# And match original analyses
usa.lm = lm(Yield ~ NewYear, data = FAOarticle, 
            subset = Country == 'United States of America')
summary(usa.lm)   

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country == 
#    "United States of America")
#
#Residuals:
#     Min       1Q   Median       3Q      Max 
#-18435.4  -1958.3    338.3   3663.8  10311.0 
#
#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 38677.34    1736.92   22.27   <2e-16 ***
#NewYear      1173.83      59.28   19.80   <2e-16 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 
#
#Residual standard error: 6049 on 48 degrees of freedom
#Multiple R-squared: 0.8909,	Adjusted R-squared: 0.8887 

weu.lm = lm(Yield ~ NewYear, data = FAOarticle,
            subset = Country == 'Western Europe')
summary(weu.lm)   

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country == 
    # "Western Europe")

#Residuals:
     # Min       1Q   Median       3Q      Max 
#-14726.6  -3205.8    346.4   4000.6  10289.5 

#Coefficients:
            # Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 31510.14    1665.90   18.91   <2e-16 ***
#NewYear      1344.42      56.86   23.65   <2e-16 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1 

#Residual standard error: 5802 on 48 degrees of freedom
#Multiple R-squared: 0.9209,	Adjusted R-squared: 0.9193 
#F-statistic: 559.1 on 1 and 48 DF,  p-value: < 2.2e-16 


# Now move to analyses that consider yields with less than 25% GM maize 
# That is, from 1961 to 1999
# For United States
usa.lm2 = lm(Yield ~ NewYear, data = FAOarticle, 
            subset = Country == 'United States of America' & Year < 2000)
summary(usa.lm2)   

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country == 
#    "United States of America" & Year < 2000)
#
#Residuals:
#   Min     1Q Median     3Q    Max 
#-17441  -2156   1123   3989   9878 
#
#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 39895.57    2084.81   19.14  < 2e-16 ***
#NewYear      1094.82      90.84   12.05 2.25e-14 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 6385 on 37 degrees of freedom
#Multiple R-squared:  0.797,	Adjusted R-squared:  0.7915 
#F-statistic: 145.2 on 1 and 37 DF,  p-value: 2.245e-14

# For Western Europe
weu.lm2 = lm(Yield ~ NewYear, data = FAOarticle,
            subset = Country == 'Western Europe' & Year < 2000)
summary(weu.lm2)   

#Call:
#lm(formula = Yield ~ NewYear, data = FAOarticle, subset = Country == 
#    "Western Europe" & Year < 2000)
#
#Residuals:
#   Min     1Q Median     3Q    Max 
#-10785  -3348    -34   3504  11117 
#
#Coefficients:
#            Estimate Std. Error t value Pr(>|t|)    
#(Intercept) 29802.17    1813.79   16.43   <2e-16 ***
#NewYear      1454.48      79.03   18.40   <2e-16 ***
#---
#Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Residual standard error: 5555 on 37 degrees of freedom
#Multiple R-squared:  0.9015,	Adjusted R-squared:  0.8988 
#F-statistic: 338.7 on 1 and 37 DF,  p-value: < 2.2e-16




# Produce plot of maize penetration
cornPenetration = read.csv('GMcornPenetration.csv')

ggplot(cornPenetration, aes(x = Year, y = PerAllGM)) + geom_line() + facet_wrap(~ State) +
      scale_y_continuous('Percentage of GM maize planted') + 
      scale_x_continuous(breaks = seq(2000, 2012, 2)) + theme_bw(base_size = 12) +
      theme(axis.text.x  = element_text(angle=90, size = 10))


# Aggregating every decade
FAOarticle$Decade = cut(FAOarticle$Year, 
                        breaks = seq(1959, 2019, 10), 
                        labels = paste(seq(1960, 2010, 10), 's', sep = ''))

decadeProd = aggregate(Production ~ Country + Decade,
                       data = FAOarticle,
                       FUN = sum)

decadeArea = aggregate(Area ~ Country + Decade,
                       data = FAOarticle,
                       FUN = sum)
                       
decadeYield = merge(decadeProd, decadeArea, by = c('Country', 'Decade'))
decadeYield$Yield = with(decadeYield, Production/Area*10000)


# And plot decade average for maize yield
ggplot(decadeYield, aes(x = Decade, y = Yield, fill = Country)) + 
       geom_bar(stat = 'identity', position = 'dodge') +
       scale_y_continuous('Maize yield [hg/ha]', expand = c(0, 0)) + scale_fill_grey() +
       theme_bw(base_size = 14) + theme(legend.position="top")


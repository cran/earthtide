## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(knitr)
library(earthtide)

## ----capabilities, echo = FALSE, results = 'asis'-----------------------------

tidal_component <- c(
  "tidal_potential", "gravity",  "tidal_tilt", "vertical_displacement", 
  "horizontal_displacement", "n_s_displacement", "e_w_displacement",
  "vertical_strain", "areal_strain", "volume_strain", "horizontal_strain",
  "ocean_tides")

output_units <- c('$meters^2/second^2$','$nanometers/second^2$', '$milliarcsec$', '$millimeter$',
                  '$millimeter$', '$millimeter$', '$millimeter$', 
                  '$nanostrain$', '$nanostrain$', '$nanostrain$', '$nanostrain$',
                  '$millimeter$')

status <- c("tested", "tested", "tested", "tested", 
            "preliminary", "preliminary","preliminary", 
            "tested","tested","tested","tested",
            "preliminary")
dat <- data.frame(tidal_component, status, output_units)
names(dat) <- c('Tidal component', 'Status', 'Output units')
kable(dat)

## ----standardmethod, echo = TRUE----------------------------------------------
tms <- as.POSIXct("2015-01-01", tz = "UTC") + 0:(24*31) * 3600

gravity_tide <- calc_earthtide(utc = tms, 
                               method = 'gravity',
                               latitude = 52.3868,
                               longitude = 9.7144)



## ----predict, echo = TRUE-----------------------------------------------------

gravity_tide <- calc_earthtide(utc = tms,
                               do_predict = TRUE,
                               method = 'gravity',
                               latitude = 52.3868,
                               longitude = 9.7144)


## ----predictplot, fig.width = 6.5, fig.height = 3, fig.ext='png', echo = FALSE----
# Plot the results
par(mai = c(0.6, 0.9, 0.1, 0.1))
plot(gravity~datetime, gravity_tide,
     ylab = expression('Gravity nm/s' ^ 2),
     xlab = '',
     type='l',
     lwd = 2,
     col = '#5696BC',
     xaxs = 'i',
     las = 1)

## ----analyze, echo = TRUE-----------------------------------------------------
wg <- eterna_wavegroups
wg <- na.omit(wg[wg$time=='1 month',])

tides <- calc_earthtide(utc = tms,
                        do_predict = FALSE,
                        method = 'gravity',
                        latitude = 52.3868,
                        longitude = 9.7144,
                        wave_groups = wg)


## ----analyzeplot, fig.width = 6.5, fig.height = 8, fig.ext='png', echo = FALSE----

layout(matrix(1:5, ncol=1, nrow = 5))
par(mai = c(0.3, 0.9, 0.1, 0.1))

for (i in seq(2, 11, 2)) {

  plot(tides[,1], tides[,i],
       ylab = expression('Gravity nm/s' ^ 2),
       xlab = '',
       type = 'l',
       lwd = 2,
       col = '#AAB6A2',
       las = 1)
  points(tides[,1], tides[,i+1],
         type = 'l',
         lwd = 2,
         col  = '#5696BC')

}



## ----analyze1month, echo = TRUE-----------------------------------------------

tms <- as.POSIXct("2015-01-01", tz = "UTC") + 0:(24*31) * 3600

wg <- eterna_wavegroups
wg <- na.omit(wg[wg$time=='1 month',])

head(wg)

## ----lodpolecalc, echo = TRUE-------------------------------------------------
tide <- calc_earthtide(utc = tms,
                       method = c('lod_tide', 'pole_tide'),
                       latitude = 52.3868,
                       longitude = 9.7144)

## ----lodpoleplot, echo = FALSE, fig.width = 6.5, fig.height = 5---------------

layout(matrix(1:2, ncol=1, nrow = 2))
par(mai = c(0.4, 0.9, 0.1, 0.1))

# Plot the results

plot(lod_tide~datetime, tide,
     xlab = '',
     ylab = expression('LOD tide nm/s' ^ 2),
     type='l',
     lwd = 2,
     col = '#5696BC',
     las = 1)

plot(pole_tide~datetime, tide,
     xlab = '',
     ylab = expression('Pole tide nm/s' ^ 2),
     type='l',
     lwd = 2,
     col = '#5696BC',
     las = 1)



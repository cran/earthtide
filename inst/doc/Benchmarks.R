## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(earthtide)
library(bench)


eval_chunks <- TRUE # may not want to run on CRAN because of threads and running time

## ----irregular, eval = eval_chunks--------------------------------------------
set.seed(123)
tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(900)
indices <- sort(sample(0:900, 100, replace = FALSE)) 

wave_groups <- data.frame(start = 0, end = 8)

check_fun <- function(target, current) (all.equal(target, current, check.attributes = FALSE))

bench::mark(
  et <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  )[indices, ],
  et_irregular <- calc_earthtide(
    utc = tms[indices],
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  ), check = check_fun, iterations = 1
)


## ----catalog, eval = eval_chunks----------------------------------------------

tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(900)

wave_groups <- data.frame(start = 0, end = 8)

bench::mark(
  et <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  ),
  et_catalog <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "hw95s",
    wave_groups = wave_groups
  ), check = FALSE, iterations = 1
)


## ----cutoff, eval = eval_chunks-----------------------------------------------

tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(1800)

wave_groups <- data.frame(start = 0, end = 8)

bench::mark(
  et <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  ),
  et_cutoff <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-5,
    catalog = "ksm04",
    wave_groups = wave_groups
  ), check = FALSE, iterations = 1
)


## ----astro_update, eval = eval_chunks-----------------------------------------

tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(900)

wave_groups <- data.frame(start = 0, end = 8)

bench::mark(
  et <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  ),
  et_astro <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups,
    astro_update = 30L
  ), iterations = 1
)



## ----threads, eval = eval_chunks----------------------------------------------

tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(900)

wave_groups <- data.frame(start = 0, end = 8)

bench::mark(
  et <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  ),
  et_threads <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups,
    n_thread = 10L
  ), iterations = 1
)



## ----predictinterp, eval = eval_chunks----------------------------------------

tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(900)
tms_interp <- as.POSIXct("1990-01-01", tz = "UTC") + seq(0, 900, 180)

wave_groups <- data.frame(start = 0, end = 8)

bench::mark(
  et <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups
  ),
  et_interp <- calc_earthtide(
    utc = tms_interp,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups,
    utc_interp = tms
  ), iterations = 1
)

  

## ----combination, eval = eval_chunks------------------------------------------

tms <- as.POSIXct("1990-01-01", tz = "UTC") + 0:(86400)
tms_interp <- as.POSIXct("1990-01-01", tz = "UTC") + seq(0, 86400, 180)

wave_groups <- data.frame(start = 0, end = 8)

bench::mark(
  et_astro_threads <- calc_earthtide(
    utc = tms,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups,
    astro_update = 60L,
    n_thread = 10L
  ),
  et_interp_threads <- calc_earthtide(
    utc = tms_interp,
    do_predict = TRUE,
    method = c("tidal_potential", "lod_tide", "pole_tide"),
    latitude = 52.3868,
    longitude = 9.7144,
    elevation = 110,
    gravity = 9.8127,
    cutoff = 1.0e-10,
    catalog = "ksm04",
    wave_groups = wave_groups,
    utc_interp = tms,
    n_thread = 10L
  ), iterations = 1
)

  


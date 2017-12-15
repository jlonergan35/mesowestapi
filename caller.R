source('mesowest_api.R')

path <- "/v2/stations/timeseries?stid=wbb&token=7bae27b7657c4d47812e9fb4760aff56&start=201312010000&end=201412011200"
call <- mesowest_api(path)
dat <- call$content
dat <- dat$STATION
dat <- dat$OBSERVATIONS
df <- data.frame(matrix(unlist(dat), ncol = ncol(dat)),stringsAsFactors=FALSE)
names(df) <- names(dat)

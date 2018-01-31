source('mesowest_api.R')

enddate <- Sys.time()
startdate <- enddate - 3000
enddate <- gsub("-","",enddate)
enddate <- gsub(" ","",enddate)
enddate <- gsub(":","",enddate)
startdate <- gsub("-","",startdate)
startdate <- gsub(" ","",startdate)
startdate <- gsub(":","",startdate)
enddate <- substr(enddate,1,nchar(enddate)-2)
startdate <- substr(startdate,1,nchar(startdate)-2)
#startdate <- "201701090000"
#enddate <- "201801080000"
stid <- "C5988"
path <- paste("/v2/stations/timeseries?stid=",stid,"&token=7bae27b7657c4d47812e9fb4760aff56&start=",startdate,"&end=",enddate,"",sep="")
call <- mesowest_api(path)
dat <- call$content
dat <- dat$STATION
dat <- dat$OBSERVATIONS
df <- data.frame(matrix(unlist(dat), ncol = ncol(dat)),stringsAsFactors=FALSE)
names(df) <- names(dat)

df$date_time <- gsub(c("T"), " ", df$date_time)
df$date_time <- gsub(c("Z"), " ", df$date_time)
df$date_time <- strftime(as.POSIXct(df$date_time, format ="%Y-%m-%d %H:%M:%S"))
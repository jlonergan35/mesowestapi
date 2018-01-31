library(nominatim)

key <- "g6ZDA3kCC8DLFxjioLEtqv5l0CgdNzoW"

test <- osm_geocode(c("Fresno, California"), key = key)
lats <- test$lat
longs <- test$lon

rad = 50

path1 <- paste("/v2/stations/metadata?network=1,2,3,4,5,6,7,8,9,10&radius=",lats,",",longs,",",rad,"&token=7bae27b7657c4d47812e9fb4760aff56")
call <- mesowest_api(path1)

out <- call$content$STATION


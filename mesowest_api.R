# real time weather getter
# Token Generator
#key <- "KzSE0yGBcCL8C3LmwS1f4wJyMqsyahectLp"
#token <- "7bae27b7657c4d47812e9fb4760aff56"
#token <- "https://api.mesowest.net/v2/auth?apikey=KzSE0yGBcCL8C3LmwS1f4wJyMqsyahectLp"

# real time weather getter
library(httr)
mesowest_api <- function(path) {
  url <- modify_url("https://api.mesowest.net", path = path)
  resp <- GET(url, encoding = "UTF-8")
  if (http_type(resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
  }
  
  parsed <- jsonlite::fromJSON(content(resp, "text", encoding = "UTF-8", simplifyVector = FALSE))
  
  structure(
    list(
      content = parsed,
      path = path,
      response = resp
    ),
    class = "mesowest_api"
  )
}
print.mesowest_api <- function(x, ...) {
  cat("<mesowest ", x$path, ">\n", sep = "")
  str(x$content)
  invisible(x)
}


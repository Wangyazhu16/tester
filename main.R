source("header.R")

get_rnorm <- get_api_paras("test_docker")
endpoint <- get_rnorm$endpoint
token <- get_rnorm$token

# a simple example
body <- list(
  token = token,
  x = 3
)

resp <- POST(endpoint, body = body, encode = "form")

# is API open?
if(resp$status_code != 200) {
  stop("API is not available.")
} else {
  message(paste("Succeed.", endpoint, "is available."))
}

# Get Some Samples --------------------------------------------------------

samples <- data.frame(
  x = sample(1:20, size = 20, replace = T)
) %>% 
  mutate(token = "some_secret") %>% 
  transpose()

post_safely <- purrr::safely(httr::POST)

cli::cat_line("连接接口输入结果...", col = "yellow")

result <- purrr::map(samples,  ~ {
  # send requests in bulk
  post_safely(endpoint,
              body = .,
              encode = "form",
              verbose())# %>%
    # keep result, ignore error
   # `[[`("result") %>%
    # extract content
    #content() #%>%
    # move inside
    #`[[`(1)
})





















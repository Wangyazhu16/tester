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

read_api_config <- function(which_api){
  
  # make sure file exists
  if(!file.exists("apiconfig.yaml")){
    stop("Require config file - apiconfig.yaml")
  }
  
  # read config
  d <- read_yaml("apiconfig.yaml")
  
  # check if the credentials are specified
  if(!all(c("host", "port", "swagger") %in% names(d[[which_api]]))){
    stop(paste("One or more parameter in", which_api, "is missing."))
  }
  
  # return endpoint
  endpoint = with(d[[which_api]], paste0(host, ":", port, "/", swagger))
  
  # return 
  endpoint
}

read_api_config("validator") %>% POST()




















From rocker/tidyverse

# Edit sources list
COPY ./sources.list /etc/apt/

RUN apt-get update && apt-get install -y \
    --allow-unauthenticated \
    --allow-downgrades \ 
    sudo \
    git-core \
    libssl-dev \
    libcurl3-gnutls=7.47.0-1ubuntu2.8 \
    libcurl4-gnutls-dev \
    # for Mongolite
    libsasl2-2=2.1.26.dfsg1-14build1 \
    libsasl2-dev \
    # for DBI
    libjpeg62-dev
  
RUN install2.r --error \
  --deps TRUE \
  # change to China mirror
  -r "http://mirrors.tuna.tsinghua.edu.cn/CRAN/" \
  mongolite \
  DBI \
  yaml \
  cli 

# Set working directory
WORKDIR /tester

# COPY scripts and stuffs
COPY . /tester

## Add the wait script to the image
RUN chmod +x /wait

#CMD ["Rscript", "--vanilla", "plumber.R", "&"]

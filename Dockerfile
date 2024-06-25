FROM debian:bullseye

LABEL maintainer="pan.luo@ubc.ca"

# libnlopt-dev is required by lmerTest
RUN apt-get update && \
    apt-get install -y gnupg2 && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      wget \
      r-base \
      r-base-dev \
      libssl-dev \
      libnlopt-dev \
      libcurl4-openssl-dev \
      && \
    rm -rf /var/lib/apt/lists/* && \
    wget --no-check-certificate https://www.rforge.net/Rserve/snapshot/Rserve_1.8-6.tar.gz && \
    R CMD INSTALL Rserve_1.8-6.tar.gz && \
    rm Rserve_1.8-6.tar.gz
# install the packages from dataverse installation guide
# https://guides.dataverse.org/en/6.2/installation/prerequisites.html#installing-the-required-r-libraries
RUN Rscript -e 'install.packages(c("R2HTML", "rjson", "DescTools", "Rserve", "haven"), repos="https://cloud.r-project.org/")'

VOLUME /localdata

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE 6311

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["R", "-e", "Rserve::run.Rserve(remote=TRUE, auth=FALSE, daemon=FALSE)"]

FROM trestletech/plumber
RUN apt-get install libxml2-dev -y
RUN R -e "install.packages('aws.s3')"
RUN R -e "install.packages('aws.ec2metadata')"
RUN R -e "install.packages('glmnet')"
RUN R -e "install.packages('jsonlite')"
RUN mkdir -p /app/
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ENV AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
WORKDIR /app/
COPY ./functionDependencies.R /app/functionDependencies.R
COPY ./api.R /app/api.R
RUN Rscript /app/functionDependencies.R
EXPOSE 8000
CMD ["/app/api.R"]

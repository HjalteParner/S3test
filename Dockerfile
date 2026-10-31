# Base R image
FROM rocker/r-ver:4.3.1

# Install required R packages
RUN R -e "install.packages('shiny', repos = 'https://cloud.r-project.org')"
RUN R -e "install.packages('aws.s3', repos = 'https://cloud.r-project.org')"

# Copy the Shiny app
COPY app.R /srv/shiny-server/app.R

# Expose the Shiny port
EXPOSE 3838

# Run the app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app.R', host='0.0.0.0', port=3838)"]
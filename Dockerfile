FROM rocker/tidyverse:latest

RUN apt-get update && apt-get install -y pandoc

RUN apt-get install -y vim

RUN mkdir /project
WORKDIR /project

RUN mkdir code
RUN mkdir f1_datasets
RUN mkdir output

COPY code code
COPY f1_datasets f1_datasets
COPY report.Rmd .
COPY Makefile .

COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.json renv

RUN Rscript -e "renv::restore(prompt = FALSE)"

RUN mkdir final_report

CMD make && mv report.html final_report/
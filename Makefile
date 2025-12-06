# REPORT-ASSOCIATED RULES
report.html: code/04_render_report.R report.Rmd descriptive_analysis regression_analysis
	Rscript code/04_render_report.R

output/data1.rds: code/00_clean_data.R f1_datasets/results.csv f1_datasets/races.csv f1_datasets/drivers.csv \
f1_datasets/qualifying.csv f1_datasets/circuits.csv
	Rscript code/00_clean_data.R
	
output/table1_vars.rds: code/00_clean_data.R output/data1.rds
	Rscript code/00_clean_data.R
	
output/table1.rds: code/01_make_table1.R output/table1_vars.rds
	Rscript code/01_make_table1.R

output/scatterplot.png: code/02_make_scatter.R output/data1.rds
	Rscript code/02_make_scatter.R

.PHONY: descriptive_analysis	
descriptive_analysis: output/table1.rds output/scatterplot.png

output/regression.rds: code/03_regression.R output/data1.rds
	Rscript code/03_regression.R

.PHONY: regression_analysis
regression_analysis: output/regression.rds

.PHONY: install
install:
	Rscript -e "renv::restore(prompt = FALSE)"

.PHONY: clean
clean:
	rm -f output/*.rds && rm -f output/*.png && rm -f final_report/*.html && rm -f *.html && rm -f *.pdf
	
# DOCKER-ASSOCIATED RULES

PROJECTFILES = report.Rmd code/00_clean_data.R code/01_make_table1.R code/02_make_scatter.R \
							 code/03_regression.R code/04_render_report.R Makefile

RENVFILES = renv.lock renv/activate.R renv/settings.json

# rule to build image
project_image: Dockerfile $(PROJECTFILES) $(RENVFILES)
	docker build -t nazizanaeer/f1_image .
	touch $@
	
# rule to build the report automatically in our container 
final_report/report.html:
	docker run -v $$(pwd)/final_report:/project/final_report nazizanaeer/f1_image





	
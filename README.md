# R_OpenAir

# ---------------------------------
# INSTALACE KNIHOVEN PRO OPENAIR
# ---------------------------------

# ---------------------------------
1. openair a openairmaps
# ---------------------------------
- v R nainstaluj nové balíky
	> install.packages("openair")
	> install.packages("openairmaps")
# ---------------------------------

# ---------------------------------
2. tidyverse
# ---------------------------------
- v terminále spusť:
	> sudo apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
- v R nainstaluj nový balík "tidyverse"
	> install.packages("tidyverse")
# ---------------------------------

# ---------------------------------
3. worldmet
# ---------------------------------
- v R nainstaluj nový balík "Rcpp"
	> install.packages("Rcpp")
	
- v terminále spusť:
	> sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
	> sudo apt-get update
	> sudo apt-get install libgdal-dev libgeos-dev libproj-dev 
	
- v R nainstaluj nový balík "terra"
	> install.packages("terra")
	
- v R nainstaluj nový balík "worldmet"
	> install.packages("worldmet")
# ---------------------------------

curl https://www.elections.alaska.gov/doc/info/2013-SW-Precinct-Proc-Plan.zip -o 2013-SW-Precinct-Proc-Plan.zip
unzip -d ak 2013-SW-Precinct-Proc-Plan.zip
mv "ak/SW Proc Shape Files" ak/2013-SW-Proc-Shape-files

curl https://www2.census.gov/geo/tiger/TIGER2014/COUNTY/tl_2014_us_county.zip -o tl_2014_us_county.zip
unzip -d tl_2014_us_county tl_2014_us_county.zip
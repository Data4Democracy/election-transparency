curl -O https://www.elections.alaska.gov/doc/info/2013-SW-Precinct-Proc-Plan.zip
unzip -d ak 2013-SW-Precinct-Proc-Plan.zip
mv "ak/SW Proc Shape Files" ak/2013-SW-Proc-Shape-files

curl -O https://www2.census.gov/geo/tiger/TIGER2016/COUNTY/tl_2016_us_county.zip
unzip -d tl_2016_us_county tl_2016_us_county.zip

curl -O http://www2.census.gov/geo/tiger/GENZ2015/shp/cb_2015_us_state_500k.zip
unzip -d cb_2015_us_state_500k cb_2015_us_state_500k.zip

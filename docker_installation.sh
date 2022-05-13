# install docker, add permissions to user ubuntu to run docker commands
sudo apt install docker.io
sudo service docker start
sudo usermod -a -G docker ubuntu

# so that user's permissions get picked up
sudo reboot 

# pull the docker image with everything ready (postgres, postgis, ...)
docker pull kartoza/postgis

# run the container
docker run --name "postgis" -p 25431:5432 -e POSTGRES_USER=niva -e POSTGRES_PASS=n1v4 -e POSTGRES_DBNAME=gisdb -e POSTGRES_MULTIPLE_EXTENSIONS=postgis,hstore -d -t kartoza/postgis

# some more things to install in order to import shp to db
sudo apt install postgis

# there are some issues with EPSG 3346 (Lithuanian crs), so in order to bypass them, I have converted the geometries to WGS84, using ogr2ogr, so I had to install gdal
sudo apt install gdal-bin

# convert to WGS84
ogr2ogr -t_srs epsg:4326 -lco ENCODING=UTF-8 -f 'Esri Shapefile' gsaa_4326.shp bucket/Declared_parcels_2019_03_S4C.shp

# create sql for import
shp2pgsql -s 4326 -I gsaa_4326.shp gsaa > gsaa.sql

# run the sql to import
psql -h localhost -U niva -p 25431 -d gisdb -f gsaa.sql
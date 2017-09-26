geoipdata=`grep GeoIP.dat /opt/APP/openresty/nginx/conf/nginx.conf | awk '{print $2}' | sed -r 's/;//g'`
wget -O $geoipdata https://raw.githubusercontent.com/hwiewie/OPS/master/GeoIP-106_20170926.dat
nginx -s reload

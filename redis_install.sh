yum install -y gcc tcl
curl -O http://download.redis.io/releases/redis-5.0.7.tar.gz
tar xzf redis-5.0.7.tar.gz
cd redis-5.0.7
make
cd src
make install
cd ../utils
./install_server.sh

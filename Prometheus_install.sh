groupadd prometheus
useradd -g prometheus -M -s /sbin/nologin prometheus
export VERSION=2.13.1
wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz
tar -zxvf prometheus-$VERSION.linux-amd64.tar.gz
mv prometheus-$VERSION.linux-amd64/ /srv/prometheus
mkdir -pv /srv/prometheus/data
chown -R prometheus.prometheus /srv/prometheus

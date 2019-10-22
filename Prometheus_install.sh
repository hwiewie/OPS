groupadd prometheus
useradd -g prometheus -M -s /sbin/nologin prometheus
export VERSION=2.13.1
wget https://github.com/prometheus/prometheus/releases/download/v$VERSION/prometheus-$VERSION.linux-amd64.tar.gz
tar -zxvf prometheus-$VERSION.linux-amd64.tar.gz
mv prometheus-$VERSION.linux-amd64/ /srv/prometheus
mkdir -pv /srv/prometheus/data
chown -R prometheus.prometheus /srv/prometheus
curl -OL https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar -zxvf node_exporter-0.18.1.linux-amd64.tar.gz
mv node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/
node_exporter

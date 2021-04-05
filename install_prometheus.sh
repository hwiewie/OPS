#!/bin/bash
useradd --no-create-home --shell /bin/false prometheus
useradd --no-create-home --shell /bin/false node_exporter
useradd --no-create-home --shell /bin/false alertmanager
yum -y install wget
curl -LO https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
curl -LO https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
tar -zxvf prometheus-*.linux-amd64.tar.gz 
cd prometheus-*.linux-amd64
cp -av prometheus promtool /usr/local/bin/
mkdir /etc/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus
mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool 
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template
mkdir -p /var/lib/alertmanager/data
cat <<EOF > /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - localhost:9093
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']      
  - job_name: 'grafana'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:3000']      
EOF

chown prometheus:prometheus /etc/prometheus/prometheus.yml
cat <<EOF  >  /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus     --config.file /etc/prometheus/prometheus.yml     --storage.tsdb.path /var/lib/prometheus/ 
[Install]
WantedBy=multi-user.target
EOF

tar xvzf alertmanager-*.linux-amd64.tar.gz
cp alertmanager-*.linux-amd64/alertmanager /usr/local/bin/
cp alertmanager-*.linux-amd64/amtool /usr/local/bin/

cat <<EOF  >   /etc/alertmanager/alertmanager.yml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alertmanager@google.com'
  smtp_auth_username: 'alertmanager'
  smtp_auth_password: 'password'
templates:
- '/etc/alertmanager/template/*.tmpl'
route:
  repeat_interval: 3h
  receiver: team-X-mails
receivers:
- name: 'team-X-mails'
  email_configs:
  - to: 'team-X+alerts@google.com'
EOF


cat <<EOF  >  /etc/systemd/system/alertmanager.service
[Unit]
Description=Prometheus Alertmanager Service
Wants=network-online.target
After=network.target
[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager/data
Restart=always
[Install]
WantedBy=multi-user.target
EOF
chown -R alertmanager:alertmanager /etc/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager

systemctl daemon-reload
systemctl enable alertmanager
systemctl enable prometheus
cd /root

curl -LO https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar zxvf node_exporter-*.linux-amd64.tar.gz
cp node_exporter-*.linux-amd64/node_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/node_exporter
rm -rf node_exporter-*
rm -rf prometheus-*

cat <<EOF >  /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
cd /root
wget https://dl.grafana.com/oss/release/grafana-7.5.2-1.x86_64.rpm
yum -y install initscripts fontconfig urw-fonts -y
rpm -Uvh grafana-7.5.2-1.x86_64.rpm
systemctl daemon-reload
sed -i '/\[metrics\]/a enabled = true' /etc/grafana/grafana.ini 
systemctl enable grafana-server.service
systemctl start grafana-server.service
systemctl start node_exporter
systemctl start prometheus
systemctl start alertmanager

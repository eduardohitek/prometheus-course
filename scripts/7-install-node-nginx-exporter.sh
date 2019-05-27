#!/bin/bash
NODE_NGINX_EXPORTER_VERSION="0.3.0"
wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v${NODE_NGINX_EXPORTER_VERSION}/nginx-prometheus-exporter-${NODE_NGINX_EXPORTER_VERSION}-linux-amd64.tar.gz
tar -xzvf nginx-prometheus-exporter-${NODE_NGINX_EXPORTER_VERSION}.linux-amd64.tar.gz
cd nginx-prometheus-exporter-${nginx-prometheus-exporter_VERSION}.linux-amd64
cp nginx-prometheus-exporter /usr/local/bin

# create user
useradd --no-create-home --shell /bin/false nginx-prometheus-exporter

chown nginx-prometheus-exporter:nginx-prometheus-exporter /usr/local/bin/nginx-prometheus-exporter

echo '[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=nginx-prometheus-exporter
Group=nginx-prometheus-exporter
Type=simple
ExecStart=/usr/local/bin/nginx-prometheus-exporter

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/nginx-prometheus-exporter.service

# enable nginx-prometheus-exporter in systemctl
systemctl daemon-reload
systemctl start nginx-prometheus-exporter
systemctl enable nginx-prometheus-exporter


echo "Setup complete.
Add the following lines to /etc/prometheus/prometheus.yml:

  - job_name: 'nginx-prometheus-exporter'
    scrape_interval: 5s
    metrics_path: '/metrics'
    static_configs:
        - targets: ['localhost:9113']
"


#!/bin/bash
apt update
apt install unzip
CONSUL_VERSION="1.6.1"
cd /usr/local/src
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS
curl --silent --remote-name https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_SHA256SUMS.sig
unzip consul_${CONSUL_VERSION}_linux_amd64.zip
chown root:root consul
mv consul /usr/local/bin/
consul --version
consul -autocomplete-install
complete -C /usr/local/bin/consul consul
useradd --system --home /etc/consul.d --shell /bin/false consul
mkdir --parents /opt/consul
chown --recursive consul:consul /opt/consul
touch /etc/systemd/system/consul.service

wget http://169.254.169.254/latest/meta-data/instance-id
INST_ID=`cat instance-id`
INST_ROLE=`cat /home/ubuntu/aws-s3.sh | grep "tar -zxf" | awk -F' ' '{ print $3 }' | awk -F'/' '{ print $4 }' | awk -F'.' '{ print $1 }'`
NODE_NAME=$INST_ROLE
NODE_NAME+="_"
NODE_NAME+=$INST_ID

cat <<EOT >> /etc/systemd/system/consul.service
[Unit]
Description="ConsulService"
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/consul.d/consul.hcl
[Service]
Type=notify
User=consul
Group=consul
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d/ -log-file=/var/log/consul.log -log-rotate-max-files=5 -node $NODE_NAME
ExecReload=/usr/local/bin/consul reload
KillMode=process
Restart=on-failure
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOT
mkdir --parents /etc/consul.d
touch /etc/consul.d/consul.hcl
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/consul.hcl
cat <<EOT > /etc/consul.d/consul.hcl
datacenter = "dc1"
data_dir = "/opt/consul"
encrypt = "xyxXYZxyxXYZ"
retry_join = ["consul-a.xyz", "consul-b.xyz"]
performance {
  raft_multiplier = 1
}
EOT
mkdir --parents /etc/consul.d
touch /etc/consul.d/client.hcl
chown --recursive consul:consul /etc/consul.d
chmod 640 /etc/consul.d/client.hcl
cat <<EOT >> /etc/consul.d/client.hcl
client_addr = "0.0.0.0"
EOT
systemctl enable consul
systemctl start consul
systemctl status consul

exit 0

# infrastructure

put different resources in different .tf files
### ec2
using environment variables (user data) to pass hostname

### download and install cloudWatch agent

#### install packer and statsd
sudo apt-get install nodejs

#### download and install collectd
sudo apt-get install collectd -y

#### download package
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

sleep 30
#### depackage
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
#### creating config file
cd /opt
sudo touch cloudwatch-config.json

#### start cloudWatch Agent

sudo bash -c 'cat>cloudwatch-config.json<<EOF
{
    "agent": {
        "metrics_collection_interval": 10,
        "logfile": "/var/logs/amazon-cloudwatch-agent.log"
    },
    "metrics":{
        "metrics_collected":{
            "collectd":{
            "name_prefix":"My_collectd_metrics_",
            "metrics_aggregation_interval":120
            },
            "mem": {
                "measurement": [
                    "used_percent",
                    "total"
                ]
            }

        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/opt/tomcat/logs/csye6225.log",
                        "log_group_name": "csye6225",
                        "log_stream_name": "webapp",
                        "timezone": "UTC"
                    }
                ]
            }
        },
        "log_stream_name": "cloudwatch_log_stream"
    }
}
EOF'

#### import ssl
aws acm import-certificate --certificate fileb://prod_joci_me.crt --certificate-chain fileb://prod_joci_me.ca-bundle --private-key fileb://CSR_PK.key

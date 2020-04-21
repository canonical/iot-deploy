#!/bin/sh


management_yaml () {
    cat > "management-config.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: management-config
  labels:
    app: management
data:
  HOST: "$1:30100"
---
EOF
}

identity_yaml () {
    cat > "identity-config.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: identity-config
  labels:
    app: identity
data:
  MQTTURL: "$1"
  MQTTPORT: "30883"
---
EOF
}

influxdb_yaml () {
    PASSWORD=`pwgen -1 16`
    echo "Influx DB Password: $PASSWORD"
    cat > "influxdb-config.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: influxdb-creds
data:
  INFLUXDB_DATABASE: metrics
  INFLUXDB_USERNAME: root
  INFLUXDB_PASSWORD: $PASSWORD
  INFLUXDB_HOST: influxdb
---
EOF
}

management_yaml $1
identity_yaml $1
influxdb_yaml
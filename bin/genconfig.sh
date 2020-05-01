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
    cat > "influxdb-config.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: influxdb-creds
data:
  INFLUXDB_DATABASE: metrics
  INFLUXDB_USERNAME: root
  INFLUXDB_PASSWORD: $1
  INFLUXDB_HOST: influxdb
---
EOF
}

mqttinflux_yaml () {
    cat > "mqttinflux-config.yaml" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: mqttinflux-config
data:
  INFLUXDB_URL: http://influxdb:8086
  INFLUXDB_USER: root
  INFLUXDB_PASSWORD: $1
  INFLUXDB_DATABASE: metrics
  MQTT_HOST: mqtt
  MQTT_PORT: "8883"
  MQTT_USER: ""
  MQTT_PASSWORD: ""
  MQTT_TOPICS: "metrics,metrics/+"
  MQTT_TLS: "true"
  MQTT_TLS_CA: /mosquitto/certs/ca.crt
  MQTT_TLS_CERT: /mosquitto/certs/server.crt
  MQTT_TLS_KEY: /mosquitto/certs/server.key
---
EOF
}

management_yaml $1
identity_yaml $1

PASSWORD=`pwgen -1 16`
echo "Influx DB Password: $PASSWORD"

influxdb_yaml "$PASSWORD"
mqttinflux_yaml "$PASSWORD"
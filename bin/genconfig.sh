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

management_yaml $1
identity_yaml $1

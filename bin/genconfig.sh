#!/bin/sh


generate_yaml () {
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

generate_yaml $1

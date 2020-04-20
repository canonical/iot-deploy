#!/bin/sh


generate_yaml () {
    PASSWORD=`pwgen -1 16`

    cat > "$1" << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-config-$2
  labels:
    app: postgres-$2
data:
  POSTGRES_DB: $3
  POSTGRES_USER: manager
  POSTGRES_PASSWORD: $PASSWORD
  DATASOURCE: "dbname=$3 host=postgres-$2 user=manager password=$PASSWORD sslmode=disable"
---
EOF

}

generate_yaml "postgres-twin.yaml" "twin" "devicetwin"
generate_yaml "postgres-man.yaml" "man" "management"
generate_yaml "postgres-id.yaml" "identity" "identity"



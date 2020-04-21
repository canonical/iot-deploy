#!/bin/sh

export PATH=$PATH:$PWD/bin

install_prerequites () {
    echo "Install dependencies..."
    sudo apt update
    sudo apt install -y pwgen
}

# Generate the certificates for MQTT, device twin and identity services
generate_certificates () {
    rm -rf certs
    mkdir certs
    cd certs
    ( exec gencerts.sh )
    cd ..
}

install_microk8s () {
    echo "Install microk8s..."
    sudo snap install microk8s --classic

    echo "Configure the user for microk8s..."
    sudo usermod -a -G microk8s $USER
    sudo chown -f -R $USER ~/.kube
    sudo microk8s status --wait-ready
}

enable_microk8s () {
    echo "Enable the microk8s services..."
    sudo microk8s.enable storage
    sudo microk8s.enable dns
    sudo microk8s status --wait-ready
}

generate_yaml () {
    cd certs
    ( exec genpostgres.sh )
    cd ..
}

generate_config () {
    cd certs
    ( exec genconfig.sh "$1" )
    cd ..
}

deploy_config () {
    cd certs
    for y in mqtt identity devicetwin postgres-id postgres-twin postgres-man management-config identity-config influxdb-config
    do
      sudo microk8s kubectl create -f "$y.yaml"
    done

    cd ..
}

deploy_services () {
    for y in mosquitto postgres-twin postgres-id postgres-man devicetwin identity management influxdb grafana
    do
      sudo microk8s kubectl create -f "kubernetes/k8s-$y.yaml"
    done
}

HOST_IP=$1

if [ -z "$HOST_IP" ]; then
    echo "The IP address or domain name of the server must be provided"
    echo "Usage:"
    echo "deploy.sh <ip-or-domain-name>"
    exit 1
fi

install_prerequites

# Generate the secrets and certificates in the certs directory
generate_certificates

# Generate the postgres config files
generate_yaml

# Generate the management service config file
generate_config "$HOST_IP"

# Install and configure microk8s
install_microk8s
enable_microk8s

# Begin service deployment to microk8s
deploy_config
deploy_services

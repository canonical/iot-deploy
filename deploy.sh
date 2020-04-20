#!/bin/sh

export PATH=$PATH:$PWD/bin

install_prerequites () {
    echo "Install dependencies..."
    sudo apt install pwgen
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

deploy_config () {
    cd certs
    sudo microk8s kubectl create -f mqtt.yaml
    sudo microk8s kubectl create -f identity.yaml
    sudo microk8s kubectl create -f devicetwin.yaml
    sudo microk8s kubectl create -f postgres-id.yaml
    sudo microk8s kubectl create -f postgres-twin.yaml
    sudo microk8s kubectl create -f postgres-man.yaml

    cd ..
}

deploy_services () {
    sudo microk8s kubectl create -f kubernetes/k8s-mosquitto.yaml
    sudo microk8s kubectl create -f kubernetes/k8s-postgres-twin.yaml
    sudo microk8s kubectl create -f kubernetes/k8s-postgres-id.yaml
    sudo microk8s kubectl create -f kubernetes/k8s-postgres-man.yaml
    sudo microk8s kubectl create -f kubernetes/k8s-devicetwin.yaml
    sudo microk8s kubectl create -f kubernetes/k8s-identity.yaml
    sudo microk8s kubectl create -f kubernetes/k8s-management.yaml
}

install_prerequites

# Generate the secrets and certificates in the certs directory
generate_certificates

# Generate the postgres config files
generate_yaml

# Install and configure microk8s
install_microk8s
enable_microk8s

# Begin service deployment to microk8s
deploy_config
deploy_services

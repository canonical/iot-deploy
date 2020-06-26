# Deploy the Iot Device Management services
The IOT Device Management service manages and monitors IoT devices running Ubuntu or Ubuntu Core.
 ![IoT Management Solution Overview](https://raw.githubusercontent.com/CanonicalLtd/iot-management/master/docs/IoTManagement.svg)

The application is based on a number of microservices:
- [IoT Management](https://github.com/CanonicalLtd/iot-management)
- [IoT Identity](https://github.com/CanonicalLtd/iot-identity)
- [IoT Device Twin](https://github.com/CanonicalLtd/iot-devicetwin)

The device agent:
- [IoT Agent](https://github.com/CanonicalLtd/iot-agent)


The scripts in this project simplify the installation of the IoT Device Management services for
testing purposes. The services are deployed on a machine using microk8s. If using `multipass`,
increase the size of the virtual machine e.g. `multipass launch -n iot -m 2048M -d 20G`


## Install the services
Automated installation of microk8s and the management services. The script needs
the IP address of the machine that is being used for the installation. This will
be used when access the service via a browser e.g. http://ip-or-domain-name:30100
```bash
cd iot-deploy
./deploy.sh <ip-or-domain-name>
```
The services will take some time to load, especially the databases as they need
to be initialized. The process can be monitored via:
```bash
sudo microk8s kubectl get pods
```
Some pods will have an error status as they wait for other services to
load, but Kubernetes will handle the retries until all the services are running.

## Register the super user with the services
User authentication is done via Ubuntu SSO. Run the script to register a user
with the service. Other users can then be created via the web interface.
```bash
cd iot-deploy
./createuser.sh <usso-username>
```

## Service URLs
- Management web interface: http://ip-or-domain-name:30100
- Identity service: http://ip-or-domain-name:30300
- MQTT service: http://ip-or-domain-name:30883
- Grafana web interface: http://ip-or-domain-name:30000

## Testing the Agent
The agent can be installed on any Ubuntu device that has access to the ip-or-domain-name. The details of the serial assertion from the device need to be registered with the Identity service by using the Management web interface (Devices > Register in the menu). The details of the brand, model and serial number can be found by running this command on the device:
```
snap known serial
```

The agent can be installed from the Snap Store and then needs to be configured with the URL to the identity service e.g.
```
sudo snap install --edge --devmode iot-agent
sudo snap set iot-agent url=http://ip-or-domain-name:30300/
```
Once installed and configured, the agent will enrol with the Identity service and will be visible in the Management service.

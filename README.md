# Deploy the Iot Device Management services

Scripts to simplify the installation of the IoT Device Management services for
testing purposes. The services are deployed on a machine using microk8s.

If using `multipass`, increase the size of the virtual machine e.g.
`multipass launch -n iot -m 2048M -d 20G`


## Install the services
Automated installation of microk8s and the management services. The script needs
the IP address of the machine that is being used for the installation. This will
be used when access the service via a browser e.g. http://<ip-or-domain-name>:30100
```bash
cd iot-deploy
./deploy.sh <ip-or-domain-name>
```

## Register the super user with the services
User authentication is done via Ubuntu SSO. Run the script to register a user
with the service. Other users can then be created via the web interface.
```bash
cd iot-deploy
./createuser.sh <usso-username>
```

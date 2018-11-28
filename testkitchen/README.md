Demo Prep using Test Kitchen

1. Create Automate server and test machine(s)
git clone this repo and move into testkitchen directory and converge Automate and test node 

```
kitchen converge
```

This will pre-install chef-client on the test node and setup the host table. If you want to demo the auto-install of chef-client only do kitchen create on the test node. You will have to add the IP of Automate into the test nodes /etc/hosts table. 

2. Login to Automate VM. Generate an API token and get the generated admin password for the UI.

```
kitchen login automate
sudo chef-automate admin-token
```


You don't need an admin-token for chef-run to report but it's easier to create than a restricted token. 

3. Configure your chef-workstation machine to foward data to Chef automate. Copy the api token you created into your .chef-workstation/config.toml 

example .chef-workstatio/config.toml 

```
[data_collector]
url="https://automate/data-collector/v0/"
token="oRLcXgRuMPcBJS_xYon65ac-BpA=" 
```

4. add your Automate server cert to your trusted certs. If you don't do this chef-run will not report to automate and will silently fail. 

```
knife ssl fetch https://automate
```


5. Login to Automate using the generated admin password 
```
https://automate 
```
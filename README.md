# chef-ad-hoc-demo
Demo Chef Workstation's ad-hoc mode and report to Chef Automate 

chef-run will fail if Chef Automate is unreacable and node can't report to chef automate. 

Prep:
1. Create Automate server and test machine(s)
git clone this repo and move into testkitchen directory  

```kitchen converge```

if you want to show chef-client install, do only create test nodes do not converge, you will have to update the etc/hosts table of the test node so it can resolve https://automate to the correct IP:

2. Login to Automate VM to get the generated admin password 
```kitchen login automate 
sudo cat /automate-credentials.toml```

3. Login to Automate and create API token 
go to https://automate 
accept 60 day demo license
Create an API token. Click Admin and on the left pannel API tokens then add API token 

4. Configure your chef-workstation machine to foward data to Chef automate

Copy the created API token you just created and Automate URL to .chef-workstation/config.toml 

example .chef-workstatio/config.toml 

```
[data_collector]
url="https://automate/data-collector/v0/"
token="oRLcXgRuMPcBJS_xYon65ac-BpA=" ```

5. add your Automate server cert to your trusted certs 

```knife ssl fetch https://automate```

Demo Script: 

#1 TDD - start with a test 
inspec exec test.rb -t ssh://vagrant:vagrant@centos
#2 make NTP pass with a resource - can check client-tab in Automate also 
chef-run ssh://vagrant:vagrant@centos package ntp
#3 see NTP pass
inspec exec test.rb -t ssh://vagrant:vagrant@centos
#4 look at a recipe
cat recipe.rb
#5 make http pass with a recipe can check client-tab in Automate also 
chef-run ssh://vagrant:vagrant@centos recipe.rb
#6 see NTP pass 
inspec exec test.rb -t ssh://vagrant:vagrant@centos
#7 checkout base http website 
http://centos1 

to do: 
add A2 demo license 
add ubuntu test node
add windows test node 
take out 1s, make just centos

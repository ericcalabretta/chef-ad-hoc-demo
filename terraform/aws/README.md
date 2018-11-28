Prep:

1. from /terraform/aws 

terraform apply

2. Grab IP address of your automate_server and your centos_node from the terraform output 

3. SSH into automate_server and get generated Automate Admin password and the api-token

sudo cat automate-credentials.toml

[centos@ec2-18-237-24-92 ~]$ sudo cat automate-credentials.toml
url = "https://ec2-18-237-24-92.us-west-2.compute.amazonaws.com"
username = "admin"
password = "2a23e20a67b54ae6bf73fe5f40fac3c4"
api-token = p81vDeYANPvvJuiw8uiGUgfzF54=

3. Add your Automate server to your workstations trused cert list  

knife ssl fetch https://FQDNofAUTOMATEURL-FIND-IN-automate-credentials.toml 

4. Update the data-collector information for your chef-workstation. 

.chef-workstation/config.toml 

[data_collector]
url="https://FQDNofYOURAUTOMATE/data-collector/v0/"
token="YOURTOKENGOESHERE"

Demo Script:

#1 TDD - start with a test

inspec exec -i ~/.ssh/ecalabretta_sa -t ssh://centos@54.213.241.119 test.rb

#2 make NTP pass with a resource - can check client-tab in Automate also

chef-run -i ~/.ssh/ecalabretta_sa ssh://centos@54.213.241.119 package ntp

#3 see NTP pass

inspec exec -i ~/.ssh/ecalabretta_sa -t ssh://centos@54.213.241.119 test.rb

#4 look at a recipe

cat recipe.rb

#5 make http pass with a recipe can check client-tab in Automate

chef-run -i ~/.ssh/ecalabretta_sa ssh://centos@54.213.241.119 recipe.rb

#6 see all tests pass

inspec exec test.rb -t ssh://vagrant:vagrant@centos

#7 checkout base http website

http://centos1


Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

centos_node_server_public_ip = 54.191.176.154
chef_automate_server_public_ip = 54.191.12.186
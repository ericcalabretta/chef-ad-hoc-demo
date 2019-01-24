# chef-ad-hoc-demo
##This is to show the Detect/Correct style demo aka Test Driven Development using InSpec and Chef-Workstation results will be reported to Chef-Automate. InSpec is used to test the linux or windows nodes, then Chef-Workstation is used to actually change those nodes to conform to policy. 

## Warning: 
Remove demo settings from your .chef-workstation/config.toml when you're done or chef-run will fail trying to report to an Automate server that no longer exists

## Usage
In order run this demo, you must first install Chef-Workstation. You can find setup docs on the [Chef-Workstation site](https://downloads.chef.io/chef-workstation).
(https://www.chef.sh/docs/chef-workstation/getting-started/)

## Terraform 
This repo includes terraform code for launching the demo in AWS, Terraform is required as a pre-req: 

[Terraform](https://www.terraform.io/intro/getting-started/install.html).

## Test Kitchen 
A partically working Test Kitchen example is in /testkitchen with vagrant/virtualbox but  terraform is a easier. Demo instructions will be for Terraform 
[Test Kitchen]
(https://kitchen.ci/docs/getting-started/introduction/).

#### Step 1: Provison you infrastructure 
1. `cd terraform/aws`
2. `cp tfvars.example terraform.tfvars`
3. edit `terraform.tfvars` with your own values
4. `terraform apply`

Once the provisioning finishes you will see the output with the Chef Automate, Centos node, and windows node's public IP addresses.

```
Apply complete! Resources: 12 added, 0 changed, 0 destroyed.

Outputs:

centos_node_server_public_ip = 54.186.236.51
chef_automate_server_public_ip = 54.149.150.79
windows_node_server_public_ip = 34.216.6.25
```

#### Step 2. Get information from your new Automate server. You'll need this to login to Automate and to configure Chef-Workstation to report status to Automate.  

1. SSH into automate_server and get generated Automate Admin password and  api-token

```ssh centos@54.149.150.79 -i ~/.ssh/your_key_name```


```
sudo cat automate-credentials.toml
url = "https://ec2-54-149-150-79.us-west-2.compute.amazonaws.com"
username = "admin"
password = "c55112d4d31a2d1dac974d15086cafd7"
api-token = qTgDQWkLxj0o2ohvJauZ9hoZWw8=
```
#### Step 3. Configure Chef-Workstation, these steps should be done from your workstation not the infrastructure we just provisoned.

1. Add your Automate server to your workstations trused cert list. If your Chef-Workstation doesn't trust the Automate Servers certificate it will not be able to send data. For a production instance you can configure Automate with a certificate that your workstation trusts to avoid this step.  

```knife ssl fetch https://AUTOMATE_URL_FROM_PRIOR_STEP
```

2. Update the data-collector information for your chef-workstation configuration file located at .chef-workstation/config.toml 

```
[data_collector]
url="https://AUTOMATE_URL_FROM_PRIOR_STEP/data-collector/v0/"
token="AUTOMATE_API-TOKEN_FROM_PRIOR_STEP"
```

3. Login to Chef Automate using the URL, username, and password.  from the automate-credentials.toml file. Accept the demo licenseing agreement, You'll need to enter your name & e-mail address. 


Simple Demo Script:
You can go straight to the Chef-Workstation commands if you want to simplify the script. I find using the InSpec tests to start helps show the changes that are being made. 

All demo commands should be run from the root of this repo

#1 TDD style demo- start with a test 

```
inspec exec -i ~/.ssh/your_key_name -t ssh://centos@54.186.236.51 test.rb

  System Package ntp
     ×  should be installed
     expected that `System Package ntp` is installed
  Service httpd
     ×  should be installed
     expected that `Service httpd` is installed
     ×  should be enabled
     expected that `Service httpd` is enabled
     ×  should be running
     expected that `Service httpd` is running

Test Summary: 0 successful, 4 failures, 0 skipped
```

#2 make the NTP test pass by using a chef resource - you can check client-tab in Automate to visualize results. Chef-run will install chef-client if needed. 
```
chef-run -i ~/.ssh/your_key_name ssh://centos@54.186.236.51 package ntp

[✔] Packaging cookbook... done!
[✔] Generating local policyfile... exporting... done!
[✔] Applying package[ntp] from resource to target.
└── [✔] [54.186.236.51] Successfully converged package[ntp].

#3 see NTP test pass

```
inspec exec -i ~/.ssh/your_key_name -t ssh://centos@54.186.236.51 test.rb

  System Package ntp
     ✔  should be installed
  Service httpd
     ×  should be installed
     expected that `Service httpd` is installed
     ×  should be enabled
     expected that `Service httpd` is enabled
     ×  should be running
     expected that `Service httpd` is running

Test Summary: 1 successful, 3 failures, 0 skipped
```

#4 look at a recipe

cat recipe.rb

#5 make the rest of the tests pass by using a recipe to complete the tasks.  You can check client-tab in Automate to visualize results after chef-run is complete. 

chef-run -i ~/.ssh/your_key_name ssh://centos@54.186.236.51 recipe.rb

#6 see all tests pass
```
inspec exec -i ~/.ssh/your_key_name -t ssh://centos@54.186.236.51 test.rb

  System Package ntp
     ✔  should be installed
  Service httpd
     ✔  should be installed
     ✔  should be enabled
     ✔  should be running

Test Summary: 4 successful, 0 failures, 0 skipped

```


#7 checkout base http website of test node

http://IP_OF_CENTOS_NODE


More advanced Demo Prep:

Update inspec.json with the values from your Automate server. In the reporter section you'll need to update the URL and token and in the compliance section you'll need to update the server and token. 


More advanced Demo Script Prep:
This demo shows both the Chef-Client and Compliance tab's in Chef Automate. It's the same test driven development formula above but we'll be using Chef Workstation with a hardening cookbook rather than a simple recipe. We'll also be using an InSpec profile and reporting the results to Automate rather than using a simple test and reporting results to the terminal. 


#1 TDD - start with a test, InSpec will report to Automate not the terminal. Chef Automate's Compliance tab for results. 


```inspec exec -i ~/.ssh/your_key_name -t ssh://centos@54.186.236.51 https://github.com/dev-sec/linux-baseline.git --json-config inspec.json
```

#2 Run the hardening cookbook - Look atChef Automate for what changed 

```
chef-run -i ~/.ssh/your_key_name ssh://centos@54.186.236.51 chef-os-hardening
[✔] Packaging cookbook... done!
[✔] Generating local policyfile... exporting... done!
[✔] Applying os-hardening::default from /Users/ecalabretta/chef-ad-hoc-demo/chef-os-hardening to target.
└── [✔] [54.186.236.51] Successfully converged os-hardening::default.
```

#3 Lets re-run InSpec to see what we remediated. The hardening cookbook won't fix everything so you'll probably see 3-4 controls that are still failing. 

```inspec exec -i ~/.ssh/ecalabretta_sa -t ssh://centos@54.186.236.51 https://github.com/dev-sec/linux-baseline.git --json-config inspec.json
```

Destroy your demo infrastructure: 

1. `cd terraform/aws`
2. `terraform destroy`


## windows demo follows the exact same script and format as the linux demo but uses windows tests and recipes
## windows password may need to be in double quotes "YOUR_WINDOWS_PASSWORD" 

Base Demo windows:
inspec exec -t winrm://34.216.6.25 --user administrator --password YOUR_WINDOWS_PASSWORD win_test.rb

## takes some time to instal chef-client on windows may want to do chef-run before demo to speed it up, 
##doesn't create the file on the first chef_run for some reason? maybe workstation bug? need to run twice which is probably a good idea anyway to not wait 5 minutes as chef-client installs on windows 

chef-run winrm://34.216.6.25 --user administrator --password YOUR_WINDOWS_PASSWORD file 'C:\test.txt'

inspec exec -t winrm://34.216.6.25 --user administrator --password YOUR_WINDOWS_PASSWORD win_test.rb

chef-run winrm://34.216.6.25 --user administrator --password YOUR_WINDOWS_PASSWORD win_recipe.rb

inspec exec -t winrm://34.216.6.25 --user administrator --password YOUR_WINDOWS_PASSWORD win_test.rb

You can also checkout the IIS splash screen https://WINDOWS_IP

Advanced Demo windows: 
inspec exec -t winrm://34.216.6.25 --user administrator --password YOUR_WINDOWS_PASSWORD https://github.com/dev-sec/windows-baseline.git --json-config win_inspec.json

##Hardening cookbook breaks WinRM for some reason - so Chef-run & InSpec doesn't work if you run the hardening cookbook. 
chef-run winrm://ec2-54-187-180-87.us-west-2.compute.amazonaws.com --user administrator --password YOUR_WINDOWS_PASSWORD chef-windows-hardening

inspec exec -t winrm://34.216.6.25 --user administrator --password "?(lvq)@FLg(?JH)gG=RD4qTHC4&3CCB8" https://github.com/dev-sec/windows-baseline.git --json-config win_inspec.json


Destroy your demo infrastructure: 

1. `cd terraform/aws`
2. `terraform destroy`
# chef-ad-hoc-demo
Demo Chef Workstation's ad-hoc mode and report to Chef Automate 

See README in /testkitchen for demo setup instructions 

Note: chef-run will fail if Chef Automate is unreacable and node can't report to chef automate. Be sure to comment out data collector settings in your .chef-workstation/config.toml after the demo or workstation will fail. 

Demo Script: 

#1 TDD - start with a test 

```inspec exec test.rb -t ssh://vagrant:vagrant@centos```

#2 make NTP pass with a resource - can check client-tab in Automate also 

```chef-run ssh://vagrant:vagrant@centos package ntp```

#3 see NTP pass

```inspec exec test.rb -t ssh://vagrant:vagrant@centos```

#4 look at a recipe

```cat recipe.rb```

#5 make http pass with a recipe can check client-tab in Automate

```chef-run ssh://vagrant:vagrant@centos recipe.rb```

#6 see all tests pass 

```inspec exec test.rb -t ssh://vagrant:vagrant@centos```

#7 checkout base http website 

http://centos1 


to do: 
add A2 demo license 
add ubuntu test node
add windows test node 
add AWS version 









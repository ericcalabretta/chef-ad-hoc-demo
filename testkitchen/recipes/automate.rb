execute 'download_a2' do
  command 'curl https://packages.chef.io/files/current/automate/latest/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate'
  action :run
  not_if { ::File.exist?('/chef-automate') }
end

execute 'create_config.toml' do
  command 'sudo ./chef-automate init-config'
  action :run
  not_if { ::File.exist?('/config.toml') }
end

execute 'tuning' do
  command 'sysctl -w vm.max_map_count=262144'
  action :run
end

execute 'tunning2' do
  command 'sysctl -w vm.dirty_expire_centisecs=20000'
  action :run
end

execute 'deploy' do
  command 'sudo ./chef-automate deploy --accept-terms-and-mlsa --skip-preflight'
  action :run
  not_if { ::File.exist?('/automate-credentials.toml') }
end

execute 'move' do
  command 'mv chef-automate /usr/local/bin'
  action :run
  not_if { ::File.exist?('/usr/local/bin/chef-automate') }
end

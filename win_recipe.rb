file 'c:\test.txt' do
  content 'content'
  action :create
end

windows_feature 'IIS-WebServerRole' do
  action :install
end
    
service 'iis' do
  service_name 'W3SVC'
  action [:enable, :start]
end
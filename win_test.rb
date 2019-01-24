
describe file('c:\test.txt') do
  it { should exist }
end

describe windows_feature('Web-Server') do
  it { should be_installed }
end
    
describe service('W3SVC') do
  it { should be_installed }
  it { should be_running }
end
    
describe port(80) do
  it { should be_listening }
end


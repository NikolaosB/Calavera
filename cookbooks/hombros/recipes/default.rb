# set up Jenkins server

directory "/var/lib/jenkins/.ssh"  do
  mode 00755
  action :create
  recursive true
end

execute 'duplicate keys' do
  cwd '/home/vagrant/.ssh'
  command 'cp id_rsa* /var/lib/jenkins/.ssh'   
end

execute 'correct Jenkins directory ownership' do
  command 'chown -R jenkins /var/lib/jenkins &&  \
          chgrp -R jenkins /var/lib/jenkins'  
end

# create credential

#jenkins_credentials 'jenkins' do
#  action :delete
#end
privkey = File.read("/home/vagrant/.ssh/id_rsa")

jenkins_private_key_credentials 'jenkins' do
  id '1ea894fc-d69e-4f2e-ba27-30bf66f774b3'  # generated this once upon a time. recommend you generate a new one.
  description 'SSH key'
  private_key privkey
  
end

# create slave
jenkins_ssh_slave 'brazos' do
  description 'Run test suites'
  remote_fs   '/home/jenkins'
  #labels      ['executor', 'freebsd', 'jail']

  # SSH specific attributes
  host        'brazos' # or 'slave.example.org'
  user        'jenkins'
  credentials 'jenkins'
end

#ESSENTIAL - set master to 0 executors


#jenkins_plugin 'git-client' do
#  action :uninstall
#end

jenkins_plugin 'git' do   #install git plugin
  #action :uninstall
  notifies :restart, 'service[jenkins]', :immediately
end

jenkins_plugin 'artifactory' do   #install artifactory plugin
  #action :uninstall
  notifies :restart, 'service[jenkins]', :immediately
end


cookbook_file "hijoInit.xml" do    # downloaded from manually defined job. todo: convert this to erb file
  path "#{Chef::Config[:file_cache_path]}/hijoInit.xml"
  mode 0744
end

xml = File.join(Chef::Config[:file_cache_path], 'hijoInit.xml')

jenkins_job 'hijoInit' do
  config xml
end

#jenkins_command 'safe-restart'

# project name hijoInit



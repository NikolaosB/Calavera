# base configuration.
# this needs to be then re-packaged to minimize virtual machine loading time while constructing the various nodes

execute 'apt update' do
  command 'apt-get -q update'   
end

include_recipe "apt::default"
include_recipe "curl::default"
include_recipe "java7::default"

execute 'install tree' do
  command 'apt-get -q install tree'   
end
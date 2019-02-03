#
# Cookbook:: vaultssh_bootstrap
# Recipe:: default
#

vault_ssh 'mytrusted-keys' do
  action :bootstrap
end

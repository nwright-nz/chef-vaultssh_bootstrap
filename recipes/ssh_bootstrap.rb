#
# Cookbook:: dd-ssh-bootstrap
# Recipe:: ssh_bootstrap
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash 'get public key' do
  code <<-KEY
    curl -o /etc/ssh/trusted-user-ca-keys.pem https://vault.businessapplications.co.nz/v1/ssh-client-signer/public_key
  KEY
end

ruby_block 'setup_profile' do
  block do
    file = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')
    file.insert_line_if_no_match(/TrustedUserCAKeys.*/,
                                 'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem')
    file.search_file_replace(/TrustedUserCAKeys.*/,
                             'TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem')
    file.write_file
  end
end

service 'sshd' do
  action :restart
end

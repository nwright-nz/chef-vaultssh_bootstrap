resource_name :vault_ssh
property :vault_url, String, default: 'https://localhost:8200'
property :ca_key_name, String, default: 'trusted-user-ca-keys'
property :vault_ssh_path, String, default: 'ssh'

action :bootstrap do
  ruby_block 'get_public_ca_key' do
    block do
      require 'net/http'
      require 'uri'
      uri = URI.parse(new_resource.vault_url + '/v1/' + new_resource.vault_ssh_path + '/public_key')
      response = Net::HTTP.get_response(uri)
      ::File.write('/etc/ssh/' + new_resource.ca_key_name + '.pub', response.body)
    end
  end
  ruby_block 'setup_profile' do
    block do
      file = Chef::Util::FileEdit.new('/etc/ssh/sshd_config')
      file.insert_line_if_no_match(/TrustedUserCAKeys.*/,
                                   'TrustedUserCAKeys /etc/ssh/' + new_resource.ca_key_name + '.pub')
      file.search_file_replace(/TrustedUserCAKeys.*/,
                               'TrustedUserCAKeys /etc/ssh/' + new_resource.ca_key_name + '.pub')
      file.write_file
    end
  end
  service 'sshd' do
    action :restart
  end
end

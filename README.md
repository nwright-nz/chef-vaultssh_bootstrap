# vaultssh_bootstrap

This cookbook is used to install the signed certificate public key on to a server to start using the Hashicorp Vault SSH secrets engine (signed ssh certificates). See this link for more details : <https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html>   

## Pre-reqs
You must have a vault server provisioned, configured and unsealed.

You also need to configure vault with the CA signing client keys. See Steps 1 and 2 here: <https://www.vaultproject.io/docs/secrets/ssh/signed-ssh-certificates.html>

Once this is done, the client signer public key is accessible via the API at the /public_key endpoint.

## Usage

To use this resource from a cookbook, add the below depends statement to the `metadata.rb` file :
```code
depends 'vaultssh_bootstrap', '~>1.0.0'
```

The resource can be used in a recipe as follows:
```ruby
vault_ssh 'bootstrap_server' do
  vault_url 'https://myvaultserver.com'
  ca_key_name 'my-public-ca-key'
  vault_ssh_path 'ssh-client-signer'
end
```

The properties are described below:   
**vault_url** - The address to your vault server, for example `https://myvaultserver.com`
   
**ca_key_name** - The name of the public key to use for client signing. The public key will be retrieved from vault and saved to /etc/ssh/<i>ca_key_name</i>.pub   

**vault_ssh_path** - This is the path the ssh secrets engine is mounted to in Vault. By default this is `ssh` but can be overridden when the secrets engine is enabled.


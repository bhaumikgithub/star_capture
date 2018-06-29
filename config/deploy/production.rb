server '18.191.101.119', user: 'ubuntu', roles: %w[web app db], primary: true
set    :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ec2/nency-ror.pem) }

set    :nginx_server_name, '18.191.101.119'
set    :stage, :production
set    :rails_env, 'production'
set    :branch, 'master'
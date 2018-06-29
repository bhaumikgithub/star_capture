# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application,    'star_capture'
set :repo_url,       'git@github.com:bhaumikgithub/star_capture.git'
set :deploy_via,     :remote_cache
set :deploy_to,      '/var/www/star_capture'
set :user,           'ubuntu'
set :pty,            false
set :use_sudo,       true
set :linked_dirs,    %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  desc 'Runs rake db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  after  :publishing,   :restart
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

namespace :deploy do
  after :restart, :clear_cache do
  end
end


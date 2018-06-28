# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application,    'star_capture'
set :repo_url,       'git@git.sd2labs.com:sdsquared/cuposugar_p395_rails.git'
set :deploy_via,     :remote_cache
set :deploy_to,      '/var/www/cup_o_sugar'
set :user,           'ubuntu'
set :pty,            false
set :use_sudo,       true
set :linked_files,   %w[config/database.yml config/secrets.yml config/APNs_production_certificate.pem config/APNs_sandbox_certificate.pem .socket_env]
set :linked_dirs,    %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system]
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }
set :sidekiq_pid,     File.join(current_path, 'tmp', 'sidekiq.pid')
set :npm_target_path, -> { release_path }

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
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
        execute 'forever stopall'
        execute "forever start -o #{release_path.join('log/forever_out.log')} -e #{release_path.join('log/forever_error.log')} --minUptime 1000 --spinSleepTime 1000 #{release_path.join('vendor/assets/javascripts/socket/server.js')}"
      end
    end
  end
end

####################################################
# Sidekiq commands
####################################################
# Run `cap staging sidekiq:start` to start sidekiq
# Run `cap staging sidekiq:stop` to stop sidekiq
# To know all tasks of sidekiq run `cap -T sidekiq`
# Also you can manage sidekiq from `/sidekiq` route
####################################################


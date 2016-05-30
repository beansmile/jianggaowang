# config valid only for Capistrano 3.1
lock '3.4.0'

set :application, 'jianggaowang'
set :repo_url, 'git@github.com:beansmile/jianggaowang.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/var/www/jianggaowang"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :info

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/secrets.yml config/oneapm.yml}

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'vendor/bundle', 'public/uploads', 'tmp/pids')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 10

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'Visit the app'
  task :visit_web do
    system "open #{fetch(:app_url)}"
  end

  after :deploy, "deploy:visit_web"
end

namespace :remote do
  desc "run rake task, usage: `cap staging remote:rake task='db:create'` "
  task :rake do
    on primary(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          info "run `rake #{ENV['task']}`"
          # inspired by https://github.com/capistrano/capistrano/issues/807
          execute :rake, ENV['task']
        end
      end
    end
  end

  desc "run rake task, usage: `cap staging remote:run command='pwd'` "
  task :run do
    on primary(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          info "run `run command='your-command'`"
          # inspired by https://github.com/capistrano/capistrano/issues/807
          execute ENV['command']
        end
      end
    end
  end

  desc "tail rails logs, usage: `cap staging remote:tail_log file=unicorn`"
  task :tail_log do
    on roles(:app) do
      with_verbosity Logger::DEBUG do
        log_file = ENV['file'] || fetch(:rails_env)
        execute "tail -f #{current_path}/log/#{log_file}.log"
      end
    end
  end

  # available output verbosity: ['Logger::DEBUG' 'Logger::INFO' 'Logger::ERROR' 'Logger::WARN']
  def with_verbosity(output_verbosity)
    old_verbosity = SSHKit.config.output_verbosity
    begin
      SSHKit.config.output_verbosity = output_verbosity
      yield
    ensure
      SSHKit.config.output_verbosity = old_verbosity
    end
  end
end


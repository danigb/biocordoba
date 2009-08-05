#############################################################
#	Application
#############################################################
 
set :application, "eventos86"
set :deploy_to, "/srv/http/staging/#{application}"
set :rails_env, 'production'
 
#############################################################
#	Settings
#############################################################
 # 
# default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false
ssh_options[:port] = 22
set :scm_verbose, true 
set :keep_releases, 2
set :use_sudo, false 

#############################################################
#	Servers
#############################################################
 
set :user, "deploy"
set :domain, "beecoder.com"
server domain, :app, :web
role :db, domain, :primary => true
 
#############################################################
#	Git
#############################################################
 
set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :repository,  'git@git.beecoder.com:agenda-eventos/mainline.git'
set :deploy_via, :remote_cache
 
#############################################################
#	database.yml generation
#############################################################
 
require 'erb'
 
  before "deploy:setup", :db
  after "deploy:update_code", "db:symlink"
 
  namespace :db do
    desc "Create database yaml in shared path"
    task :default do
      db_config = ERB.new <<-EOF
      base: &base
        adapter: mysql
        username: root
        password:
        encoding: utf8
 
      development:
        database: #{application}_development
        <<: *base
 
      production:
        database: #{application}_production
        <<: *base
      EOF
 
      run "mkdir -p #{shared_path}/config"
      put db_config.result, "#{shared_path}/config/database.yml"
    end
 
    desc "Make symlink for database yaml, mongrel cluster"
    task :symlink do     
      run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"      
      run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"      
    end   
  end
 
 
#############################################################
#	Passenger
#############################################################
 
namespace :deploy do
 
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
 
end

# Capistrano Recipes for managing delayed_job
#
# Add these callbacks to have the delayed_job process restart when the server
# is restarted:
#
after "deploy:stop", "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:restart", "delayed_job:restart"
 
 
namespace :delayed_job do
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path}; script/delayed_job -e #{rails_env} stop"
  end
 
  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path}; script/delayed_job -e #{rails_env} start"
  end
 
  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path}; script/delayed_job -e #{rails_env} restart"
  end
end

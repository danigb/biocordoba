#Multi Stage#
require 'yaml'
GIT = YAML.load_file("#{File.dirname(__FILE__)}/git.yml")

set :default_stage, "development"
set :stages, %w(production development)
require 'capistrano/ext/multistage'
set :scm_passphrase, GIT['password']

#############################################################
#	Application
#############################################################
set :rails_env, 'production'
#############################################################
#	Settings
#############################################################
ssh_options[:forward_agent] = true
ssh_options[:paranoid] = false
ssh_options[:port] = 22
set :scm_verbose, true 
set :keep_releases, 2
set :use_sudo, false 

#############################################################
#	Servers
#############################################################
 
set :user, "superage"
 
#############################################################
#	Git
#############################################################
 
set :scm, :git
set :branch, "master"
set :scm_user, 'git'
set :repository,  'git://github.com/danigb/biocordoba.git'
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
    run "cd #{current_path} && script/delayed_job -e #{rails_env} stop"
  end
 
  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path} && script/delayed_job -e #{rails_env} start"
  end
 
  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    run "cd #{current_path} && script/delayed_job -e #{rails_env} restart"
  end
end


namespace :mysql do
  task :download, :roles => :db, :only => { :primary => true } do
    filename = "#{application}.dump.sql"
    file = "/tmp/#{filename}"
    on_rollback { delete file }
    db = YAML::load(ERB.new(IO.read(File.join(File.dirname(__FILE__), 'database.yml'))).result)
    production = db['production']
    run "mysqldump -u #{production['username']} --password=#{production['password']} #{production['database']} > #{file}"  do |ch, stream, data|
      puts data
    end
    get file, "tmp/#{filename}"
    puts "mysql -u root -p #{db['development']['database']} < tmp/#{filename}"
    #`mysql -u root -p booka < tmp/#{filename}`
    # delete file
  end
end

desc "Create asset packages for production" 
task :after_update_code do
  run <<-EOF
   cd #{release_path} && rake asset:packager:build_all
  EOF
end

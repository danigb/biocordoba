set :application, "agenda"
set :deploy_to, "/srv/http/#{application}"
set :domain, "agenda.beecoder.com"
set :user, "deploy"
set :deploy_port, "3000"
set :cluster_instances, "3"
set :server, "thin"
set :shared_config_path,   "#{shared_path}/config"

server domain, :app, :web
role :db, domain, :primary => true

namespace :thin do
  desc "Generate a thin configuration file"
  task :build_configuration, :roles => :app do
    config_options = {
      "user"        => user,
      "group"       => user,
      "log"    => "#{current_path}/log/thin.log",
      "chdir"         => current_path,
      "port"        => deploy_port,
      "servers"     => cluster_instances.to_i,
      "environment" => "production",
      "address"     => "localhost",
      "pid"    => "#{current_path}/tmp/pids/log.pid"
    }.to_yaml
    put config_options, shared_configuration_location_for(:thin)
  end
  
  desc "Links the configuration file"
  task :link_configuration_file, :roles => :app do
    run "ln -nsf #{shared_configuration_location_for(:thin)} #{public_configuration_location_for(:thin)}"
  end
  
  desc "Setup Thin Cluster After Code Update"
  task :link_global_configuration, :roles => :app do
    run "ln -nsf #{shared_configuration_location_for(:thin)} /etc/thin/#{application}.yml"
  end
  
  %w(start stop).each do |action|
  desc "#{action} this app's Thin Cluster"
    task action.to_sym, :roles => :app do
      run "thin #{action} -C #{shared_configuration_location_for(:thin)}"
    end
  end

  desc "Restart the app"
  task :restart do
    # if Capistrano::CLI.ui.ask("########## Are You using GOD as monitor? (yes|no): ##########") == "yes"
    #   run "thin stop -C #{shared_configuration_location_for(:thin)}"
    # else
      run "thin restart -C #{shared_configuration_location_for(:thin)}"
    # end
  end
end

def shared_configuration_location_for(server = :thin)
  "#{shared_config_path}/#{server}.yml"
end

def public_configuration_location_for(server = :thin)
  "#{current_path}/config/#{server}.yml"
end

namespace :deploy do
  %w(start stop restart).each do |action|
    desc "#{action} our server"
    task action.to_sym do
      find_and_execute_task("thin:#{action}")
    end
  end
end

after "deploy:setup",   "thin:build_configuration"
after "deploy:symlink", "thin:link_configuration_file"

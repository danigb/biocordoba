set :application, "eventos86"
set :deploy_to, "/var/www/#{application}"
set :domain, "wiki.beecoder.com"
server domain, :app, :web
role :db, domain, :primary => true

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

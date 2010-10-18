set :application, "biocordoba"
set :deploy_to, "/home/superage/publicado/#{application}"
set :domain, "superagencia86.com"
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

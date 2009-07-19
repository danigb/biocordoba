ActionController::Routing::Routes.draw do |map|
  map.resources :preferences

  map.resources :sectors

  map.root :controller => 'main'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.type_users '/users/type/:type', :controller => 'users', :action => 'type'

  map.resources :users
  map.resource :session

  map.namespace :admin do |admin|
    admin.resources :preferences
  end

  # map.root :controller => "welcome"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

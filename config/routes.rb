ActionController::Routing::Routes.draw do |map|
  map.resources :preferences
  map.resources :sectors

  map.root :controller => 'main'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/admin/users/register', :controller => 'Admin::Users', :action => 'create'
  map.signup '/admin/users/registro', :controller => 'Admin::Users', :action => 'new'

  map.resource :session

  map.type_users '/admin/users/type/:type', :controller => 'Admin::Users', :action => 'type'
  map.namespace :admin do |admin|
    admin.resources :preferences
    admin.resources :users
  end

  # map.root :controller => "welcome"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

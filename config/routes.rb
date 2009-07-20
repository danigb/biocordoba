ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'main'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/admin/users/register', :controller => 'admin/users', :action => 'create'
  map.signup '/admin/users/registro', :controller => 'admin/users', :action => 'new'
  map.type_users '/admin/users/type/:type', :controller => 'admin/users', :action => 'type'

  map.resources :preferences
  map.resources :sectors
  map.resource :session
  map.admin '/admin', :controller => 'admin/main', :action => 'show'

  map.namespace :admin do |admin|
    admin.resources :preferences
    admin.resources :users
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

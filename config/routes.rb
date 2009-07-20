ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'main'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/admin/users/register', :controller => 'Admin::Users', :action => 'create'
  map.signup '/admin/users/registro', :controller => 'Admin::Users', :action => 'new'
  map.type_users '/admin/users/type/:type', :controller => 'Admin::Users', :action => 'type'

  map.resources :preferences
  map.resources :sectors
  map.resource :session
  map.admin '/admin', :controller => 'Admin::Main', :action => 'show'

  map.namespace :admin do |admin|
    admin.resources :preferences
    admin.resources :users
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

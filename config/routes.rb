ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'main'
  map.home "/home", :controller => 'main', :action => 'home'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/admin/users/register', :controller => 'admin/users', :action => 'create'
  map.signup '/admin/users/registro', :controller => 'admin/users', :action => 'new'
  map.type_users '/admin/users/type/:type', :controller => 'admin/users', :action => 'type'
  map.meeting_into_and '/meetings/into/:host_id/and/:guest_id', :controller => 'meetings', :action => 'new'

  map.admin '/admin', :controller => 'admin/main', :action => 'show'
  map.extenda "/extenda", :controller => 'extenda/main', :action => 'show'

  map.resources :sectors
  map.resource :session
  map.resources :messages, :collection => {:received => :get, :sent => :get}
  map.resources :profiles
  map.resources :meetings

  map.namespace :admin do |admin|
    admin.resources :preferences
    admin.resources :users
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

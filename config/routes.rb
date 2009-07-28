ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'main', :action => 'home'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/admin/usuarios/registro', :controller => 'admin/users', :action => 'create'
  map.signup '/admin/usuarios/registro', :controller => 'admin/users', :action => 'new'
  map.type_users '/admin/usuarios/tipo/:type', :controller => 'admin/users', :action => 'type'
  map.meeting_into_and '/citas/entre/:host_id/y/:guest_id', :controller => 'meetings', :action => 'new'
  map.search '/buscador', :controller => 'users', :action => 'search'
  map.development '/changelog', :controller => 'development', :action => 'changelog'

  map.admin '/admin', :controller => 'admin/main', :action => 'show'
  map.extenda "/extenda", :controller => 'extenda/main', :action => 'show'

  map.resources :sectors, :as => 'sectores'
  map.resources :profiles, :as => 'perfiles'
  map.resources :meetings, :as => 'citas'
  map.resource :session
  map.resources :messages, :as => 'mensajes', :collection => {:received => :get, :sent => :get, 
    :auto_complete_for_profile_company_name => :get}
  map.resources :users, :as => 'usuarios', :collection => {:search => :any}

  map.namespace :admin do |admin|
    admin.resources :preferences, :as => 'preferencias'
    admin.resources :users, :as => 'usuarios'
    admin.resources :monitors, :as => 'monitores', :collection => {:messages => :get}
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

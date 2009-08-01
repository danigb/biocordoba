ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'main', :action => 'home'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/usuarios/registro', :controller => 'users', :action => 'create'
  map.signup '/usuarios/nuevo', :controller => 'users', :action => 'new'

  map.new_admin '/usuarios/nuevo/administrador', :controller => 'users', :action => 'new_admin_extenda'
  map.register_admin '/usuarios/registro/administrador', :controller => 'users', :action => 'create_admin_extenda'

  map.type_users '/usuarios/tipo/:type', :controller => 'users', :action => 'type'
  map.meeting_into_and '/citas/entre/:host_id/y/:guest_id', :controller => 'meetings', :action => 'new'
  map.search '/buscador', :controller => 'users', :action => 'search'
  map.development '/changelog', :controller => 'development', :action => 'changelog'

  map.resources :sectors, :as => 'sectores'
  map.resources :profiles, :as => 'perfiles'
  map.resources :meetings, :as => 'citas'
  map.resource  :session
  map.resources :messages, :as => 'mensajes', :collection => {:received => :get, :sent => :get, 
    :auto_complete_for_profile_company_name => :get}
  map.resources :users, :as => 'usuarios', :collection => {:search => :any}

  map.resources :preferences, :as => 'preferencias'
  map.resources :monitors, :as => 'monitores', :collection => {:messages => :get}

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

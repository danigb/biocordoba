Breadcrumb.configure do
  # Specify name, link title and the URL to link to
  crumb :admin_root, "Administración", :admin_url
  crumb :admin_users, "Usuarios", :admin_users_url
  crumb :admin_users_type, '#{params[:type]}', :type_users_url, :params => :type
  crumb :admin_preferences, "Preferencias", :admin_preferences_url

  # Specify controller, action, and an array of the crumbs you specified above
  trail "admin/users", :index, [:admin_root]
  trail "admin/preferences", :index, [:admin_root]
  trail "admin/users", :type, [:admin_root, :admin_users]
  trail "admin/users", :new, [:admin_root, :admin_users]
  trail "admin/users", :edit, [:admin_root, :admin_users]
  trail "admin/preferences", [:new, :edit], [:admin_root, :admin_preferences]

  # Specify the delimiter for the crumbs
  delimit_with " - "
end


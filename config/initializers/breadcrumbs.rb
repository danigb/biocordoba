Breadcrumb.configure do
  # Specify name, link title and the URL to link to
  crumb :admin_root, "Administración", :admin_url
  crumb :admin_users, "Usuarios", :admin_users_url
  crumb :admin_preferences, "Preferencias", :admin_preferences_url

  # Specify controller, action, and an array of the crumbs you specified above
  trail "Admin::Main", :show, [:admin_root]
  trail "admin/users", :index, [:admin_root, :admin_users]
  trail "admin/preferences", :index, [:admin_root, :admin_preferences]

  # Specify the delimiter for the crumbs
  delimit_with " - "
end


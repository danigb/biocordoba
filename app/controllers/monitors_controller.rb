class MonitorsController < ApplicationController
  access_control :DEFAULT => 'admin'

  def messages
    # @users = User.find(:all, :include => :user_messages, :conditions => ["user_messages.state = ?", 'unread'])
    @users = User.find_by_sql("SELECT u.id, p.company_name as company_name, p.id as profile_id, (select count(*) from user_messages um where um.state='unread' AND receiver_id = u.id) AS unread FROM users u INNER JOIN roles_users ON roles_users.user_id=u.id INNER JOIN roles ON roles_users.role_id = roles.id and roles.title != 'admin' AND roles.title!='extenda' AND roles.title != 'international_buyer' AND u.state = 'enabled' INNER JOIN profiles p ON p.user_id = u.id ORDER BY unread desc").paginate(:per_page => 20, :page => params[:page])
  end
end

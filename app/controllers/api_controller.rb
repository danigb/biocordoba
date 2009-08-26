class ApiController < ApplicationController
  skip_before_filter :login_required

  def exhibitors
    @users = User.exhibitors.find(:all, :include => :profile)
    
    render :xml => @users.to_xml(:include => :profile, 
      :except => [:id, :login, :password, :created_at, :external, :preference_id, :remember_token, 
                  :remember_token_expires_at, :state, :updated_at, :town_id, :province_id, :user_id],
      :methods => [:province_name, :town_name])
      
  end
end

class ApiController < ApplicationController
  skip_before_filter :login_required

  def exhibitors
    @users = User.exhibitors.find(:all, :include => :profile)

    respond_to do |format|
      format.xml{}
    end

    # render :xml => @users.to_xml(:include => :profile, 
    #   :only => [:id, :company_name])
  end

  def exhibitor

  end

  def sectors

  end

  def search

  end
end

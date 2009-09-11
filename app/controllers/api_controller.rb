class ApiController < ApplicationController
  skip_before_filter :login_required

  def index
    render :layout => false
  end

  def exhibitors

    if params[:sector].present? && params[:name].present?
      conditions = ["sectors.id = ? AND LOWER(profiles.company_name) LIKE ? AND state != 'disabled'", params[:sector], "%" + params[:name].downcase + "%"]
    elsif params[:sector].present?
      conditions = ["sectors.id = ? AND state != 'disabled'", params[:sector]]
    elsif params[:name].present?
      conditions = ["LOWER(profiles.company_name) LIKE ? AND state != 'disabled'", "%" + params[:name].downcase + "%"]
    end

    @users = User.exhibitors.find(:all, :include => {:profile => :sectors}, :conditions => conditions)

    respond_to do |format|
      format.xml{}
    end

    # render :xml => @users.to_xml(:include => :profile, 
    #   :only => [:id, :company_name])
  end

  def exhibitor
    @exhibitor = User.exhibitors.find(params[:id])
    @profile = @exhibitor.profile if @exhibitor
  end

  def sectors
    @sectors = Sector.all
  end

  def search

  end
end

class ApiController < ApplicationController
  skip_before_filter :login_required

  def index
    render :layout => false
  end

  def exhibitors

    if params[:sector_id].present? && params[:name].present?
      conditions = ["sectors.id = ? AND LOWER(profiles.company_name) LIKE ?", params[:sector_id], "%" + params[:name].downcase + "%"]
    elsif params[:sector_id].present?
      conditions = ["sectors.id = ?", params[:sector_id]]
    elsif params[:name].present?
      conditions = ["LOWER(profiles.company_name) LIKE ?", "%" + params[:name].downcase + "%"]
    end

    @users = User.exhibitors.find(:all, :include => {:profile => :sectors}, :conditions => conditions)

    respond_to do |format|
      format.xml{}
    end

    # render :xml => @users.to_xml(:include => :profile, 
    #   :only => [:id, :company_name])
  end

  def exhibitor

  end

  def sectors
    render :xml => Sector.all.to_xml(:only => [:id, :name, :english_name])
  end

  def search

  end
end

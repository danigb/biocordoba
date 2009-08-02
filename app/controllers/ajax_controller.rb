class AjaxController < ApplicationController
  def towns
    @towns = Town.find(:all, :conditions => { :province_id => params[:province_id] } )
    respond_to do |format|
      format.js {
        render :update do |page|
          page["town"].replace_html(:partial => "town", :locals => {:towns => @towns})
        end
      }
    end
  end

  def buyers
    @buyers = User.buyers.find(:all, :include => :profile, :conditions => ["profiles.sector_id = ?", params[:sector_id]] )
    respond_to do |format|
      format.js {
        render :update do |page|
          page["buyers"].replace_html(:partial => "buyers", :locals => {:buyers => @buyers})
        end
      }
    end
  end

  def to_meeting
    redirect_to meeting_into_and_path(params[:host][:id], params[:guest][:id])
  end

  def meetings_for
    redirect_to meetings_for_path(params[:user][:id])
  end
end

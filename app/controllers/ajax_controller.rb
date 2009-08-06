class AjaxController < ApplicationController
  access_control :DEFAULT => ('admin | extenda'), [:to_meeting, :buyers] => 'exhibitor'

  def towns
    @towns = Town.find(:all, :conditions => { :province_id => params[:province_id]}, :order => 'name' )
    respond_to do |format|
      format.js {
        render :update do |page|
          page["town"].replace_html(:partial => "town", :locals => {:towns => @towns})
        end
      }
    end
  end

  def buyers
    @buyers = User.buyers.find(:all, :include => {:profile => :sectors}, :conditions => ["sectors.id = ?", params[:sector_id]] )
    respond_to do |format|
      format.js {
        render :update do |page|
          page["buyers"].replace_html(:partial => "buyers", :locals => {:buyers => @buyers})
        end
      }
    end
  end

  def meetings
    user = User.find(params[:host_id])
    @meetings = user.meetings(Date.parse(params[:date]))

    respond_to do |format|
      format.js {
        render :update do |page|
          page["meetings-#{params[:host_id]}"].replace_html(:partial => 'meetings', :locals => {:meetings => @meetings, :guest => params[:guest]})
          page.visual_effect :slide_down, "meetings-#{params[:host_id]}"
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

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
    #Los ids de los usuarios con los que ya tenemos citas (1,2,3)
    @buyers = User.buyers.find(:all, :include => {:profile => :sectors}, 
      :conditions => ["sectors.id = ? AND users.id NOT IN (select m.guest_id from meetings m where m.host_id = #{current_user.id} 
                     AND m.state != 'canceled')", params[:sector_id]] )

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
    date = params[:date].blank? ? CONFIG[:admin][:preferences][:event_start_day] : params[:date]
    @meetings = user.meetings(Date.parse(date))

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
    @user = User.find(params[:user][:id])
    redirect_to meetings_for_path(@user.to_param)
  end
end

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
end

class MainController < ApplicationController
  skip_before_filter :login_required, :only => :index
  before_filter :redirect_to_zone, :only => :index

  def index
    render :layout => 'extended'
  end

  def home
    @date = Time.parse("22-09-2009 19:00")
    @start_date = Date.new(@date.year, @date.month, @date.day) 
    @events = Meeting.find(:all, :conditions => ['starts_at between ? and ?', @start_date, @start_date + 7])
  end
end

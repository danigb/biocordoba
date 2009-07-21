class MainController < ApplicationController
  skip_before_filter :login_required, :only => :index
  before_filter :redirect_to_zone, :only => :index

  def index
    render :layout => 'extended'
  end

  def home

  end
end

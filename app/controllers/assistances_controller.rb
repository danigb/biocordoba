class AssistancesController < ApplicationController
  before_filter :load_preference

  def index
    @user = User.find(params[:user_id])
    if [1,2,3].include?(@preference.id)
      @preference = Preference.new(Preference.first.attributes)
      @preference.save!
      @preference.users << @user
      redirect_to assistances_path(:preference_id => @preference.id, :user_id => @user.id)
    end
      @assistances = @preference.assistances
  end

  def edit
    respond_to do |format|
      format.js{
        render :update do |page|
          page[:new_assistance].replace_html(:partial => 'edit')
          page[:new_assistance].show
        end 
      }
    end
  end

  def new
    respond_to do |format|
      format.js{
        @assistance = Assistance.new
        render :update do |page|
          page[:new_assistance].replace_html(:partial => 'new')
          page[:new_assistance].show
        end 
      }
    end
  end

  def update
    if @assistance.update_attributes(params[:assistance])
      respond_to do |format|
        format.js{
          @assistances = @preference.assistances
          render :update do |page|
            page[:assistances].replace_html(:partial => "/assistances/assistance_table", :locals => {:assistances => @preference.assistances} )
          end
        }
      end
    else
      respond_to do |format|
        format.js{
          render :update do |page|
            page[:errors].replace_html("<div class='flash-message' id='flash_error'>Las fechas no son correctas</div>")
          end
        }
      end
    end
  end


  def destroy
    @assistance = @preference.assistances.find(params[:id])
    if @assistance.destroy
      respond_to do |format|
        format.js{
          @assistances = @preference.assistances
          render :update do |page|
            page[:assistances].replace_html(:partial => "/assistances/assistance_table", :locals => {:assistances => @preference.assistances} )
          end
        }
      end
    end
  end

  def create
    @assistance = @preference.assistances.build(params[:assistance])
    respond_to do |format|
      format.js{
        if @assistance.save
          render :update do |page|
            page[:assistances].replace_html(:partial => "/assistances/assistance_table", :locals => {:assistances => @preference.assistances} )
          end
        else
          render :update do |page|
            page[:errors].replace_html("<div class='flash-message' id='flash_error'>Las fechas no son correctas</div>")
          end
        end
      }
    end
  end

  private

  def load_preference
    @preference = Preference.find(params[:preference_id]) if params[:preference_id]
    @assistance = Assistance.find(params[:id]) if params[:id]
  end

end

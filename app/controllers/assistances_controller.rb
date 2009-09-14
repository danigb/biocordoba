class AssistancesController < ApplicationController
  before_filter :load_preference

  def index
    @user = User.find(params[:user_id])
    if [1,2,3].include?(@preference.id)
      @preference = Preference.new(Preference.first.attributes)
      @preference.save!
      @preference.users << @user
      create_default_assistances(@preference)
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
    if @assistance.save
      respond_to do |format|
        format.js{
          render :update do |page|
            page[:assistances].replace_html(:partial => "/assistances/assistance_table", :locals => {:assistances => @preference.assistances} )
          end
        }
      end
    end
  end

  private

  def load_preference
    @preference = Preference.find(params[:preference_id]) if params[:preference_id]
    @assistance = Assistance.find(params[:id]) if params[:id]
  end

  def create_default_assistances(preference)
    %w(22 23 24).each do |day|
      Assistance.create(:day => Date.parse("#{day}-09-2009"), :preference_id => preference.id, :arrive => Time.parse("10:00"), :leave => Time.parse("19:00"))
    end
  end
end

class PreferencesController < ApplicationController
  access_control :DEFAULT => 'admin'

  def index
    @preferences = Preference.all
  end
  
  def edit
    @preference = Preference.find(params[:id])
  end
  
  def update
    @preference = Preference.find(params[:id])
    if @preference.update_attributes(params[:preference])
      flash[:notice] = "Configuración actualizada."
      redirect_to preferences_url
    else
      render :action => 'edit'
    end
  end
  
  def new
    @preference = Preference.new
  end
  
  def create
    @preference = Preference.new(params[:preference])
    if @preference.save
      flash[:notice] = "Configuración creada."
      redirect_to admin_preferences_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @preference = Preference.find(params[:id])
    if @preference.destroy
      flash[:notice] = "Configuración eliminada."
    else
      flash[:error] = "Error al borrar la configuración."
    end
    redirect_to preferences_path
  end
end

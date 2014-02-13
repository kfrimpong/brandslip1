class ApplicationController < ActionController::Base
#  protect_from_forgery
  
  def button_show
    # Save form data...
    render :json => 'success'
  end
  
  def is_profile_complete    
    if(!current_user.nil? && current_user.is_processed == 0)
      session[:is_complete_profile] = false
      
      redirect_to edit_profile1_path
    end
  end  
  
  def after_sign_in_path_for(resource_or_scope)
    Rails.logger.debug("after sign in path............")
    Rails.logger.debug("current user - #{current_user.id}")
    if !current_user.nil? and current_user.is_processed == 0
      session[:is_complete_profile] = false
      edit_profile1_path
    else
      dashboard_url
    end
  end  
  
end

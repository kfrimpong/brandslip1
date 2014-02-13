class PasswordsController < Devise::PasswordsController
    layout "login_layout", :only => [:new, :create]
    def new
        super
    end
    
    def create
      Rails.logger.debug("----------------------------")
      self.resource = resource_class.send_reset_password_instructions(params[:user])

      if successfully_sent?(resource)
        render :json => {"response" => "1"}
      else
        render :json => {"response" => "0"}
      end
   end
   
   def edit
     super
   end
  
    def update
      Rails.logger.debug("==============================")
        self.resource = resource_class.reset_password_by_token(params[:user])

        if resource.errors.empty?
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message(:notice, "New password has been saved")
#          redirect_to new_user_session_path
          render :json => {:success => true}
        else
#          Rails.logger.debug("++++++++++++++++++++#{devise_error_messages!}")
#          respond_with resource
          render :json => {:success => false, "errors" => resource.errors}
        end
    end
    
end
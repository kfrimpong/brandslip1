class DevisesessionController < Devise::SessionsController

  def create

    Rails.logger.debug(params[:user][:email])
    user = User.find_by_email(params[:user][:email])
    Rails.logger.debug(resource_name)
    if(!user.nil?)

      Rails.logger.debug(user.is_approved)
      Rails.logger.debug(user.is_approved == 1)
      if(user.is_approved == 1)
        
        resource = warden.authenticate(:scope => resource_name)
        
        if !resource.nil?
          Rails.logger.debug("--------------------------")
          Rails.logger.debug(resource)
          Rails.logger.debug("--------------------------")
          session[:user] = resource.id
          render :json => {:success => true}
        else
         Rails.logger.debug("Inside failure.........")
         render:json => {:success => false, :errors => ["Invalid password."]}
        end
      else
        render :json => {:success => false, :errors => ["Please wait till an admin approves"]}           
      end
    else
      render :json => {:success => false, :errors => ["Invalid username and password"]}        
    end
  end
    
  def failure
    
    Rails.logger.debug("Inside failure.........")
    render:json => {:success => false, :errors => ["Invalid username or pword."]}
  end 
  
end

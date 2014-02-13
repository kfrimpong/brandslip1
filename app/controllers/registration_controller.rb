class RegistrationController < Devise::RegistrationsController
    def new
    super
  end
  
  def create
    
    @user = User.new(params[:user])     
    user_failure = false
    if @user.valid?   
        
          if @user.save()  # validation took place in the if condition
            
           user=@user
            
            logger.info "user #{@user.email} saved "
            UserMailer.welcome_email(user).deliver

          else
            user_failure = true
            logger.info "user #{@user.email} could not save. Errors = #{@user.errors.inspect}"
          end
    else
      #validation failed. No attempt to get sub_id has been made
      user_failure = true
    end    
    
    if user_failure == false
        render :json => {"response" => "1"}
    else 
        render :json => {"response" => "0", "error" => @user.errors}
    end
      
  end
  
  def update
    super  
  end 
end

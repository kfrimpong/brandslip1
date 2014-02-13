class UserMailer < ActionMailer::Base


  def welcome_email(user)  
    @user = user
    mail(to: @user.email, subject: 'Confirmation instructions',cc: 'info@brandslip.com', :from => "BrandSlip <info@brandslip.com>", :reply_to => "BrandSlip <info@brandslip.com>")
  end

  def notifier_suggestion(user_name, user_email, job_title)
    
    @user_name = user_name
    @job_title = job_title
     mail(:to => user_email, :from => "BrandSlip <info@brandslip.com>", :subject => "BrandSlip Suggestion Created")
  end

  

  def notifier(user_name, user_email, job_title)
    @user_name = user_name
    @job_title = job_title
     mail(:to => user_email, :from => "BrandSlip <info@brandslip.com>", :subject => "BrandSlip Created")
  end


  def proposal_notifier(job_user_name, proposal_user_name, job_user_email, job_details, proposal_details)
    @job_user_name = job_user_name
    @proposal_user_name = proposal_user_name
    @job_details = job_details
    @proposal_details = proposal_details
     mail(:to => job_user_email, :from => "BrandSlip <info@brandslip.com>", :subject => "BrandSlip proposal created")
  end
  def proposal_job_notifier(job_user_name, proposal_user_name, job_user_email, job_details, proposal_details)
    @job_user_name = job_user_name
    @proposal_user_name = proposal_user_name
    @job_details = job_details
    @proposal_details = proposal_details
     mail(:to => job_user_email, :from => "BrandSlip <info@brandslip.com>", :subject => "BrandSlip proposal created")
  end

   def proposal_suggestion_notifier(suggestion_user_name, proposal_user_name, suggestion_user_email, suggestion_details, proposal_details)
    
    @suggestion_user_name = suggestion_user_name
    @proposal_user_name = proposal_user_name
    @suggestion_details = suggestion_details
    @proposal_details = proposal_details
     mail(:to => suggestion_user_email, :from => "BrandSlip <info@brandslip.com>", :subject => "BrandSlip Suggestion proposal created")
  end

  def approve_notification(email, user_name, action)
    @user_name = user_name
    @action = action
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Brandslip Admin Approval")
  end

  def contact_us_notifier(contact_us_detail)
    @contact_us = contact_us_detail
    mail(:to => @contact_us['email'], :from => "BrandSlip <info@brandslip.com>", :cc => "info@brandslip.com", :bcc => "jaydhomse@gmail.com", :subject => "BrandSlip Contact Us")
  end
  
  def message_notifier(msg_title, msg_body, from_user, to_user)
    @msg_title = msg_title
    @msg_body = msg_body
    @from_user = "#{from_user.first_name} #{from_user.last_name}"
    @to_user = "#{to_user.first_name} #{to_user.last_name}"
    mail(:to => to_user.email, :from => "BrandSlip <info@brandslip.com>", :bcc => "kofi@gmail.com", :subject => "BrandSlip Message: #{msg_title}")
  end
  
  def decline_bid_notification(email, user_name, job_title)
    @user_name = user_name
    @job_title = job_title
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Brandslip Bid Declined")
  end
  
  def accept_bid_notification(email, user_name, job_title)
    @user_name = user_name
    @job_title = job_title
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Brandslip Bid Accepted")
  end

  def delete_job_notification(email, brand_full_name, presenter_full_name, job_title)
    @brand_full_name = brand_full_name
    @presenter_full_name = presenter_full_name
    @job_title = job_title
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Brandslip Cancelled")
  end

  def delete_suggestion_notification(email, brand_full_name, presenter_full_name, title)
    @brand_full_name = brand_full_name
    @presenter_full_name = presenter_full_name
    @suggestion_title = title
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Brandslip Suggestion Cancelled")
  end
  
  def delete_accepted_bid_notification(email, brand_full_name, presenter_full_name)
    @brand_full_name = brand_full_name
    @presenter_full_name = presenter_full_name
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Bid Cancelled")
  end
  def delete_accepted_job_bid_notification(email, brand_full_name, presenter_full_name)
    @brand_full_name = brand_full_name
    @presenter_full_name = presenter_full_name
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Bid Cancelled")
  end
  
  def presenter_mark_done_notification(email, brand_full_name, presenter_full_name)
    @brand_full_name = brand_full_name
    @presenter_full_name = presenter_full_name
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Mark BrandSlip As Complete")    
  end
  
  def brand_mark_done_notification(email, brand_full_name, presenter_full_name)
    @brand_full_name = brand_full_name
    @presenter_full_name = presenter_full_name
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Mark BrandSlip As Complete")    
  end
  def get_in_touch(email,comment,name)
    @email=email
    @comment=comment
    @name=name
    mail(:to => email, :from => "BrandSlip <info@brandslip.com>", :subject => "Get In Touch",:cc => "info@brandslip.com")
  end
    


end

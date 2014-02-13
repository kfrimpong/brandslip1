Brandslip::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors =  true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true
  config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'ALLOWALL'
  }

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => 587,
#  :domain               => 'gmail.com',
#  :user_name            => 'brandslip@gmail.com',
#  :password             => 'jaibrands123',
#  :authentication       => 'login',
#  :enable_starttls_auto => true
#}
   :address              => "smtp.mandrillapp.com",
    :port                 => 587,
    :domain               => 'brandslip.com',
    :user_name            => 'kofi@brandslip.com',
    :password             => 'ygD4x_wsFE7aQguz6A7LVg',
    :authentication       => "plain",
    :enable_starttls_auto => false,
    :openssl_verify_mode  => 'none'

}

  APP_CONFIG['balanced_secret'] = 'ak-test-1lsgVyVpbqb6LeIfFxoT4mB0CHvW68wL'
  APP_CONFIG['balanced_marketplace_uri'] = '/v1/marketplaces/TEST-MP7xlGFU4AcGeaNNHjT3iHKa'
end

class BrandslipController < ApplicationController
  layout 'brandslip_layout'
  before_filter :is_profile_complete, :except => [:edit_profile, :save_user]
  
  def home

    @user_jobs = Job.where(:job_user_id => current_user.id, :is_presenter_reviewed => nil)
    @brandslip_suggestions = BrandslipSuggestion.where(:user_id => current_user.id, :is_brand_reviewed => nil)
    
    @user_proposals = Job.find_by_sql("select j.id id, j.*, ujp.job_id, ujp.id proposal_id,
                                              j.job_title job_title,
                                              ujp.proposal_details, j.job_user_id, j.is_assigned
                                              from jobs j, user_job_proposals ujp 
                                              where j.id=ujp.job_id and j.is_brand_reviewed is null and ujp.user_id=#{current_user.id} 
                                              order by ujp.created_at desc")
    @suggestion_proposals = BrandslipSuggestion.find_by_sql("select bs.id id, bs.*, usp.suggestion_id, usp.id proposal_id,
                                                                    usp.proposal_details
                                                             from brandslip_suggestions bs, user_suggestion_proposals usp
                                                             where bs.id=usp.suggestion_id and bs.is_presenter_reviewed is null and usp.user_id=#{current_user.id}
                                                             order by usp.created_at desc")
    
    @inbox = UserMessage.where(:to_user => current_user.id).order("id desc")
    @inbox.each do |msg|
      user = User.find(msg.from_user)
      if !user.nil?
        msg[:from] = user.email
        msg[:first_name] = user.first_name
        msg[:last_name] = user.last_name
        msg[:company_name] = user.company_name
        msg[:user_interest_id] = user.interest
      else
        msg[:from] = "--"
        msg[:first_name] = "--"
        msg[:last_name] = "--"
        msg[:company_name] = "--"
        msg[:user_interest_id] = "--"
      end
    end
    @sent_msg = UserMessage.where(:from_user => current_user.id).order("id desc")
    @sent_msg.each do |msg|
      user = User.find(msg.to_user)
      if !user.nil?
        msg[:to] = user.email
        msg[:first_name] = user.first_name
        msg[:last_name] = user.last_name
        msg[:company_name] = user.company_name        
      else
        msg[:to] = "--"
        msg[:first_name] = "--"
        msg[:last_name] = "--"
        msg[:company_name] = "--"        
      end
    end
    buddies_ids = current_user.followeds.map(&:id)
    @ribbits = Ribbit.find_all_by_user_id buddies_ids 
    @contact_u = ContactU.new
  end
  
  def search_job
    
    @search_job_category =[]
    @search_job_category<<"Health/Fitness"
    @search_job_category<<"Fashion/Apparel"
    @search_job_category<<"Other"
    @search_job_category<<"Comedy"
    page = params[:page].nil? || !params[:page].present? ? 1 : params[:page]
    if(current_user.nil?)
      redirect_to home_url
      return
    end
    job_type_filter = ""
    if(params[:job_type] == "public_speaking")
      job_type_filter = " and job_type=1 "
    elsif(params[:job_type] == "online")
      job_type_filter = " and job_type=2 "
    end
    # if !current_user.balanced_customer_uri.nil? 
      if(params[:title].present? && !params[:title].nil?)
        @jobs = Job.paginate_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and is_assigned is null and job_user_id not in (#{current_user.id}) and job_title like '%#{params[:title]}%' #{job_type_filter} order by id desc", :page => page, :per_page => 10)
      else
        @jobs = Job.paginate_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and is_assigned is null and job_user_id not in (#{current_user.id}) #{job_type_filter} order by id desc", :page => page, :per_page => 10)
      end
    # else
    #   session[:value]="search_job_edit_account"
    #   redirect_to root_path
    # end  
  end  
  
  def search_job_filter
    if(current_user.nil?)
      redirect_to home_url
      return
    end    
    Rails.logger.debug(params[:category_arr])
    Rails.logger.debug(params[:job_type])
    Rails.logger.debug(params[:crowd_size_arr])
    Rails.logger.debug(params[:category_arr].include? "-1")
    crowd_size_clause = ""
    if(params[:crowd_size_arr].include? "-1")
      crowd_size_clause = ""
    else
      crowd_size_clause += "and ("
      crowd_size_length = params[:crowd_size_arr].length
      index = 0
      params[:crowd_size_arr].each do |crowd_size|
        if((index + 1) == crowd_size_length)
          crowd_size_clause += " crowd_size='#{crowd_size}' "
        else
          crowd_size_clause += " crowd_size='#{crowd_size}' or "
        end
        index = index + 1
      end
      crowd_size_clause += ") "
    end
    
    money_clause = ''
    if(params[:money_arr].include? "-1")
      money_clause = ""
    else
      money_clause += "and ("
      money_size_length = params[:money_arr].length
      index = 0
      params[:money_arr].each do |money_size|
        if((index + 1) == money_size_length)
          money_clause += " (job_price_fixed_type>=#{money_size.split('-')[0]} and  job_price_fixed_type<=#{money_size.split('-')[1]})"
        else
          money_clause += " (job_price_fixed_type>=#{money_size.split('-')[0]} and  job_price_fixed_type<=#{money_size.split('-')[1]}) or "
        end
        index = index + 1
      end
      money_clause += ") "
    end
    
    online_media_source_clause = ""
    if(params[:online_media_source_arr].include? "-1")
      online_media_source_clause = ""
    else
      online_media_source_clause += "and ("
      online_media_source_length = params[:online_media_source_arr].length
      index = 0
      params[:online_media_source_arr].each do |source|
        if((index + 1) == online_media_source_length)
          online_media_source_clause += " online_media_source='#{source}' "
        else
          online_media_source_clause += " online_media_source='#{source}' or "
        end
        index = index + 1
      end
      online_media_source_clause += ") "
    end
    
    follow_sub_clause = ""
    if(params[:follow_sub_arr].include? "-1")
      follow_sub_clause = ""
    else
      follow_sub_clause += "and ("
      follow_sub_length = params[:follow_sub_arr].length
      index = 0
      params[:follow_sub_arr].each do |f_s|
        if((index + 1) == follow_sub_length)
          follow_sub_clause += " followers_subscribers='#{f_s}' "
        else
          follow_sub_clause += " followers_subscribers='#{f_s}' or "
        end
        index = index + 1
      end
      follow_sub_clause += ") "
    end
    
    sub_category_clause = ""
    if(params[:sub_category_arr].include? "-1")
      sub_category_clause = ""
    else
      sub_category_clause += "and ("
      sub_category_length = params[:sub_category_arr].length
      index = 0
      params[:sub_category_arr].each do |sub_category|
        if((index + 1) == sub_category_length)
          sub_category_clause += " job_sub_category=#{sub_category} "
        else
          sub_category_clause += " job_sub_category=#{sub_category} or "
        end
        index = index + 1
      end
      sub_category_clause += ") "
    end
    
    job_type = ''
    if(params[:job_type] == 'public_speaking')
      job_type += " and job_type=1 "
    elsif(params[:job_type] == 'online')
      job_type += " and job_type=2 "
    end
    
    if(params[:category_arr].include? "-1")
      @jobs = Job.find_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) #{crowd_size_clause} #{money_clause} #{sub_category_clause} #{job_type} #{online_media_source_clause} #{follow_sub_clause} order by id desc")
    else
      category_str = params[:category_arr].join(",")
      @jobs = Job.find_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) #{crowd_size_clause} #{money_clause} and job_category in (#{category_str}) #{sub_category_clause} #{job_type} #{online_media_source_clause} #{follow_sub_clause} order by id desc")
    end
    render :template => "brandslip/_all_jobs", :layout => false
  end
  
  def search_job_filter_by_location
    @jobs = Job.find_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) and state='#{params[:state]}' and city='#{params[:city]}' order by id desc")
    render :template => "brandslip/_all_jobs", :layout => false
  end
  
  def search_job_filter_by_valid_for
    job_type = ''
    if(params[:job_type] == 'public_speaking')
      job_type += " and job_type=1 "
    elsif(params[:job_type] == 'online')
      job_type += " and job_type=2 "
    end
    
    if(params[:valid_for] == 'newly_posted')
      @jobs = Job.find_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) #{job_type} order by job_valid_for - DATEDIFF(now() , created_at) desc")
    else
      @jobs = Job.find_by_sql("select * from jobs where is_assigned is null and DATE_ADD(created_at, INTERVAL job_valid_for day)>now() and job_user_id not in (#{params[:job_user_id]}) #{job_type} order by job_valid_for - DATEDIFF(now() , created_at)")
    end
    
    render :template => "brandslip/_all_jobs", :layout => false
  end
  
  def search_suggestion

    # @search_jobcategory =[]
    # @search_jobcategory<<"Health/Fitness"
    # @search_jobcategory<<"Fashion/Apparel"
    # @search_jobcategory<<"Other"
    # @search_jobcategory<<"Comedy"
    @search_jobcategory =[]
    @search_jobcategory<<"Health/Fitness"
    @search_jobcategory<<"Entertainment/Gaming"
    @search_jobcategory<<"Fashion/Apparel"
    @search_jobcategory<<"Mobile Apps"
    @search_jobcategory<<"Major Brands"
    @search_jobcategory<<"Technology"
    @search_jobcategory<<"Other"
    page = params[:page].nil? || !params[:page].present? ? 1 : params[:page]
    if(current_user.nil?)
      redirect_to home_url
      return
    end
    suggestion_type_filter = ""
    if(params[:type] == "public_speaking")
      suggestion_type_filter = " and suggestion_type=1 "
    elsif(params[:type] == "online")
      suggestion_type_filter = " and suggestion_type=2 "
    end
    # if !current_user.balanced_customer_uri.nil? 

      if(params[:title].present? && !params[:title].nil?)
        @suggestions = BrandslipSuggestion.paginate_by_sql("select * from brandslip_suggestions where is_assigned is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and is_assigned is null and user_id not in (#{current_user.id}) and title like '%#{params[:title]}%' #{suggestion_type_filter} order by id desc", :page => page, :per_page => 10)
      else
        @suggestions = BrandslipSuggestion.paginate_by_sql("select * from brandslip_suggestions where is_assigned is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and is_assigned is null and user_id not in (#{current_user.id}) #{suggestion_type_filter} order by id desc", :page => page, :per_page => 10)
      end

    # else
    #   session[:search_suggestion]="search_suggestion_edit_profile"
    #   redirect_to root_path
    # end

  
  end  

  def search_suggestion_filter
    if(current_user.nil?)
      redirect_to home_url
      return
    end
    
    Rails.logger.debug(params[:category_arr])
    Rails.logger.debug(params[:suggestion_type])
    Rails.logger.debug(params[:crowd_size_arr])
    Rails.logger.debug(params[:category_arr].include? "-1")
    crowd_size_clause = ""
    if(params[:crowd_size_arr].include? "-1")
      crowd_size_clause = ""
    else
      crowd_size_clause += "and ("
      crowd_size_length = params[:crowd_size_arr].length
      index = 0
      params[:crowd_size_arr].each do |crowd_size|
        if((index + 1) == crowd_size_length)
          crowd_size_clause += " crowd_size='#{crowd_size}' "
        else
          crowd_size_clause += " crowd_size='#{crowd_size}' or "
        end
        index = index + 1
      end
      crowd_size_clause += ") "
    end
    
    money_clause = ''
    if(params[:money_arr].include? "-1")
      money_clause = ""
    else
      money_clause += "and ("
      money_size_length = params[:money_arr].length
      index = 0
      params[:money_arr].each do |money_size|
        if((index + 1) == money_size_length)
          money_clause += " (price>=#{money_size.split('-')[0]} and  price<=#{money_size.split('-')[1]})"
        else
          money_clause += " (price>=#{money_size.split('-')[0]} and  price<=#{money_size.split('-')[1]}) or "
        end
        index = index + 1
      end
      money_clause += ") "
    end
    
    online_media_source_clause = ""
    if(params[:online_media_source_arr].include? "-1")
      online_media_source_clause = ""
    else
      online_media_source_clause += "and ("
      online_media_source_length = params[:online_media_source_arr].length
      index = 0
      params[:online_media_source_arr].each do |source|
        if((index + 1) == online_media_source_length)
          online_media_source_clause += " online_media_source='#{source}' "
        else
          online_media_source_clause += " online_media_source='#{source}' or "
        end
        index = index + 1
      end
      online_media_source_clause += ") "
    end
    
    follow_sub_clause = ""
    if(params[:follow_sub_arr].include? "-1")
      follow_sub_clause = ""
    else
      follow_sub_clause += "and ("
      follow_sub_length = params[:follow_sub_arr].length
      index = 0
      params[:follow_sub_arr].each do |f_s|
        if((index + 1) == follow_sub_length)
          follow_sub_clause += " followers_subscribers='#{f_s}' "
        else
          follow_sub_clause += " followers_subscribers='#{f_s}' or "
        end
        index = index + 1
      end
      follow_sub_clause += ") "
    end
    
    sub_category_clause = ""
    if(params[:sub_category_arr].include? "-1")
      sub_category_clause = ""
    else
      sub_category_clause += "and ("
      sub_category_length = params[:sub_category_arr].length
      index = 0
      params[:sub_category_arr].each do |sub_category|
        if((index + 1) == sub_category_length)
          sub_category_clause += " sub_category=#{sub_category} "
        else
          sub_category_clause += " sub_category='#{sub_category}' or "
        end
        index = index + 1
      end
      sub_category_clause += ") "
    end
    
    suggestion_type = ''
    if(params[:suggestion_type] == 'public_speaking')
      suggestion_type += " and suggestion_type=1 "
    elsif(params[:suggestion_type] == 'online')
      suggestion_type += " and suggestion_type=2 "
    end
    
    if(params[:category_arr].include? "-1")
      if request.referrer.include? "online"
         @suggestions = BrandslipSuggestion.find_by_sql("select * from brandslip_suggestions where is_assigned is null and online_media_source is not null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) #{crowd_size_clause} #{money_clause} #{sub_category_clause} #{suggestion_type} #{online_media_source_clause} #{follow_sub_clause} order by id desc")
      else
         @suggestions = BrandslipSuggestion.find_by_sql("select * from brandslip_suggestions where is_assigned is null and online_media_source is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) #{crowd_size_clause} #{money_clause} #{sub_category_clause} #{suggestion_type} #{online_media_source_clause} #{follow_sub_clause} order by id desc")

      end   
    else
      category_str = params[:category_arr].join(",")
      
      if request.referrer.include? "online"
      @suggestions = Job.find_by_sql("select * from brandslip_suggestions where is_assigned is null and online_media_source is not null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) #{crowd_size_clause} #{money_clause} and category in (#{category_str}) #{sub_category_clause} #{suggestion_type} #{online_media_source_clause} #{follow_sub_clause} order by id desc")
      else
      @suggestions = Job.find_by_sql("select * from brandslip_suggestions where is_assigned is null and online_media_source is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) #{crowd_size_clause} #{money_clause} and category in (#{category_str}) #{sub_category_clause} #{suggestion_type} #{online_media_source_clause} #{follow_sub_clause} order by id desc")

      end
    end
    
    render :template => "brandslip/_all_suggestions", :layout => false
  end
  
  def search_suggestion_filter_by_location
    suggestion_type = ''
    if(params[:suggestion_type] == 'public_speaking')
      suggestion_type += " and suggestion_type=1 "
    elsif(params[:suggestion_type] == 'online')
      suggestion_type += " and suggestion_type=2 "
    end    
    
    @suggestions = Job.find_by_sql("select * from brandslip_suggestions where is_assigned is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) and state='#{params[:state]}' and city='#{params[:city]}' #{suggestion_type} order by id desc")
    render :template => "brandslip/_all_suggestions", :layout => false
  end
  
  def search_suggestion_filter_by_valid_for
    suggestion_type = ''
    if(params[:suggestion_type] == 'public_speaking')
      suggestion_type += " and suggestion_type=1 "
    elsif(params[:suggestion_type] == 'online')
      suggestion_type += " and suggestion_type=2 "
    end
    
    if(params[:valid_for] == 'newly_posted')
      @suggestions = BrandslipSuggestion.find_by_sql("select * from brandslip_suggestions where is_assigned is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) #{suggestion_type} order by valid_for - DATEDIFF(now() , created_at) desc")
    else
      @suggestions = BrandslipSuggestion.find_by_sql("select * from brandslip_suggestions where is_assigned is null and DATE_ADD(created_at, INTERVAL valid_for day)>now() and user_id not in (#{params[:suggestion_user_id]}) #{suggestion_type} order by valid_for - DATEDIFF(now() , created_at)")
    end
    
    render :template => "brandslip/_all_suggestions", :layout => false
  end  
  
  def user_job_detail
      response.headers.delete('X-Frame-Options')
      @job_details = Job.where(:id => params[:id])
      if(!@job_details[0].nil? && (!@job_details[0].is_assigned.nil?) && @job_details[0].is_assigned != 0)
         @users_applied_for_job = UserJobProposal.where(:id => @job_details[0].assigned_to)
      else
        if current_user.user_type == 1
          @users_applied_for_job = UserJobProposal.where(:job_id => params[:id], :user_id => current_user.id).order("id desc")
        else
          @users_applied_for_job = UserJobProposal.where(:job_id => params[:id]).order("id desc")
        end        
      end
      @users_applied_for_job.each do |proposal|
        proposal["first_name"] = User.where(:id => proposal.user_id)[0]['first_name']
        proposal["last_name"] = User.where(:id => proposal.user_id)[0]['last_name']
      end      
  end
  
  def user_suggestion_detail
      response.headers.delete('X-Frame-Options')
      @suggestion_details = BrandslipSuggestion.where(:id => params[:id])
      if(!@suggestion_details[0].nil? && (!@suggestion_details[0].is_assigned.nil?) && @suggestion_details[0].is_assigned != 0)
        @users_applied_for_suggestion = UserSuggestionProposal.where(:id => @suggestion_details[0].assigned_to)
      else
        if current_user.user_type == 2
          @users_applied_for_suggestion = UserSuggestionProposal.where(:suggestion_id => params[:id], :user_id => current_user.id).order("id desc")
        else
          @users_applied_for_suggestion = UserSuggestionProposal.where(:suggestion_id => params[:id]).order("id desc")
        end        
      end
      @users_applied_for_suggestion.each do |proposal|
        proposal["first_name"] = User.where(:id => proposal.user_id)[0]['first_name']
        proposal["last_name"] = User.where(:id => proposal.user_id)[0]['last_name']
      end      
  end
  
  def job_detail
    if !current_user.balanced_customer_uri.nil? 
      @job_details = Job.where(:id => params[:id])
      @user_job_proposal = UserJobProposal.new
      @users_applied_for_job = UserJobProposal.where(:job_id => params[:id]).order("id desc")
      @users_applied_for_job.each do |proposal|
        proposal["first_name"] = User.where(:id => proposal.user_id)[0]['first_name']
        proposal["last_name"] = User.where(:id => proposal.user_id)[0]['last_name']
      end
    else
      session[:value]="search_job_edit_account"
      redirect_to root_path
    end  

  end

  def edit_bid
      @job_details = Job.where(:id => params[:id])
      @user_job_proposal = UserJobProposal.find(params[:proposal_id])
      @users_applied_for_job = UserJobProposal.where(:job_id => params[:id]).order("id desc")
      @users_applied_for_job.each do |proposal|
        proposal["user_name"] = User.where(:id => proposal.user_id)[0]['full_name']
      end
  end   
  
  def suggestion_detail
    if !current_user.balanced_customer_uri.nil? 
      @suggestion_details = BrandslipSuggestion.where(:id => params[:id])
      @user_suggestion_proposal = UserSuggestionProposal.new

    else
      session[:search_suggestion]="search_suggestion_edit_profile"
      redirect_to root_path
    end
  end

  def edit_suggestion_bid
      @suggestion_details = BrandslipSuggestion.where(:id => params[:id])
      @user_suggestion_proposal = UserSuggestionProposal.find(params[:proposal_id])
      @users_applied_for_suggestion = UserSuggestionProposal.where(:suggestion_id => params[:id]).order("id desc")
      @users_applied_for_suggestion.each do |proposal|
        proposal["user_name"] = User.where(:id => proposal.user_id)[0]['full_name']
      end
  end     
  
  def send_message
    
    Rails.logger.debug(params[:from_user_id])
    Rails.logger.debug(params[:to_user_id])
    Rails.logger.debug(params[:message_title])
    Rails.logger.debug(params[:message_body])
    from_user = User.find(params[:from_user_id])
    to_user = User.find(params[:to_user_id])
    um = UserMessage.new(:from_user => params[:from_user_id], :to_user => params[:to_user_id],
                          :message_title => params[:message_title], 
                          :message_body => params[:message_body])
    um.save     
    if(!to_user.nil?)
      UserMailer.message_notifier(params[:message_title], params[:message_body], from_user, to_user).deliver
    end
    render :json => {}
  end
  
  def brand_profile

    @brand_jobcategory =[]
    @brand_jobcategory<<"Health/Fitness"
    @brand_jobcategory<<"Entertainment/Gaming"
    @brand_jobcategory<<"Fashion/Apparel"
    @brand_jobcategory<<"Mobile Apps"
    @brand_jobcategory<<"Major Brands"
    @brand_jobcategory<<"Technology"
    @brand_jobcategory<<"Other"
    # @brand_jobcategory =[]
    # @brand_jobcategory<<"Health/Fitness"
    # @brand_jobcategory<<"Fashion/Apparel"
    # @brand_jobcategory<<"Other"
    # @brand_jobcategory<<"Comedy"

    if(current_user.nil?)
      redirect_to home_url
      return 
    end
    
    if(params[:full_name].present? && !params[:full_name].nil?)
     @brands = User.find_by_sql("select * from users where user_type = 1 and is_approved=1 and (first_name like '%#{params[:full_name]}%' or last_name like '%#{params[:full_name]}%') order by id desc")

    else
      @brands =[]
      @brand = User.find_by_sql("select * from users where user_type = 1 and is_approved=1 order by id desc")
      @brand.each do |brand|
        if !brand.interest.nil? && !brand.description.nil?
          @brands<< brand
        end
      end

    end
    @relationship = Relationship.new    
  end
  
  def presenter_profile
    @inf_jobcategory =[]
    @inf_jobcategory<<"Health/Fitness"
    @inf_jobcategory<<"Fashion/Apparel"
    @inf_jobcategory<<"Other"
    @inf_jobcategory<<"Comedy"

    # @inf_jobcategory =[]
    # @inf_jobcategory<<"Health/Fitness"
    # @inf_jobcategory<<"Entertainment/Gaming"
    # @inf_jobcategory<<"Fashion/Apparel"
    # @inf_jobcategory<<"Mobile Apps"
    # @inf_jobcategory<<"Major Brands"
    # @inf_jobcategory<<"Technology"
    # @inf_jobcategory<<"Other"
    if(current_user.nil?)
      redirect_to home_url
      return 
    end    
    if(params[:full_name].present? && !params[:full_name].nil?)
     @presenters = User.find_by_sql("select * from users where user_type = 2 and is_approved=1 and (first_name like '%#{params[:full_name]}%' or last_name like '%#{params[:full_name]}%') order by id desc")
    else
      @presenters=[]
      @presenter = User.find_by_sql("select * from users where user_type = 2 and is_approved=1 order by id desc")
      @presenter.each do |presenter|
          if !presenter.interest.nil? && !presenter.description.nil?
            @presenters<< presenter
          end
        end
    end
    @relationship = Relationship.new    
  end
  
  def presenters_profile_edit
    @presenters_profile_edit = User.find(params[:id])
  end
  
def presenters_update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "presenters_profile_edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def brands_profile_edit
    @brands_profile_edit = User.find(params[:id])
  end
  
  def delete_messages
    Rails.logger.debug(params[:delete_message_id])
    UserMessage.delete_all("id=#{params[:delete_message_id]}")
    render :json => {}
  end
  
  def edit_profile

    @user=current_user
    ratings = UserRating.where(:to_user => current_user.id)
    total_ratings = 0.00
    ratings.each do |rating|
        total_ratings = total_ratings + rating.rating.to_f if !rating.rating.nil?
    end
    @avg_rating = 0
    if(ratings.size > 0)
      @avg_rating = (total_ratings/ratings.size).to_f
    end
    @users = User.find(current_user.id) 
    @brands = User.where(:user_type => 1).reject{ |user| user.balanced_customer_uri.nil? }
    @presenters = User.where(:user_type => 2).reject{ |user| user.balanced_customer_uri.nil? }
    if current_user.balanced_customer_uri
      Balanced.configure(APP_CONFIG['balanced_secret'])
      c = Balanced::Customer.find(current_user.balanced_customer_uri)
      @cards = c.cards

      @bank_accounts = c.bank_accounts
    end 



  @user = User.find(current_user.id)
  @reviews = UserRating.where(:to_user => @user.id)
  @relationship = Relationship.new
  
  end
  
  def view_profile
    @users = User.find(current_user.id) 
  end
  
  def save_user

    @user = User.find(current_user.id) 
    Rails.logger.debug params
    @user.update_attributes(params[:user])
    @user.is_processed = 1
    @user.save
    session[:is_complete_profile] = nil
    if !params[:user][:image].blank?
      render :json => {name: "Upload"}
    else
      render :json => {name: "No_image"}  
    end

  end
 
 def delete_job_proposal
  
   Rails.logger.debug("#{params[:proposal_id]}")
   proposal = UserJobProposal.find(params[:proposal_id])
   if(!proposal.nil? && !proposal.job_id.nil?)     
     job = Job.find(proposal.job_id)
     if(!job.nil? && job.is_assigned.nil? && !job.job_user_id.nil?)
       brand = User.find(proposal.user_id)
       brand_full_name = "#{brand.first_name} #{brand.last_name}"
       #Delete In process Brandslip bid.... Notify to presenter to create new brandslip
       presenter = User.find(job.job_user_id)
       presenter_full_name = "#{presenter.first_name} #{presenter.last_name}"
       UserMailer.delete_accepted_job_bid_notification(presenter.email,brand_full_name, presenter_full_name).deliver
     end
   end
   UserJobProposal.delete_all("id=#{params[:proposal_id]}")
   render :json => {}
 end
 
 def show_approve_popup

 end
 
 def delete_suggestion_proposal
  
   Rails.logger.debug("#{params[:proposal_id]}")
   proposal = UserSuggestionProposal.find(params[:proposal_id])
   if(!proposal.nil? && !proposal.suggestion_id.nil?)     
     suggestion = BrandslipSuggestion.find(proposal.suggestion_id)
     if(!suggestion.nil? && suggestion.is_assigned.nil? && !suggestion.user_id.nil?)
       presenter = User.find(proposal.user_id)
       presenter_full_name = "#{presenter.first_name} #{presenter.last_name}"
       #Delete In process Brandslip bid.... Notify to presenter to create new brandslip
       brand = User.find(suggestion.user_id)
       brand_full_name = "#{brand.first_name} #{brand.last_name}"
     UserMailer.delete_accepted_bid_notification(brand.email,presenter_full_name, brand_full_name).deliver
     end
   end
   UserSuggestionProposal.delete_all("id=#{params[:proposal_id]}")
   render :json => {}
 end
 
 def edit_job_proposal
   
 end
 
 def followings_users
   @followings = current_user.followeds
 end
 
 def followers_users
   @followers = current_user.followers
 end
 
 def add_newsfeed
   ribbit = Ribbit.new(:user_id => current_user.id, :content => params[:newsfeed_desc])
   ribbit.save
   render :json => {}
 end
 
 def your_posts
   @posts = Ribbit.where(:user_id => current_user.id)
 end
 
 def delete_post
   Ribbit.delete_all("id=#{params[:post_id]}")
   render :json => {}
 end
   
 def get_cities
   Rails.logger.debug(params[:state])
   state = State.where(:state => params[:state])
   matched_cities = []
   if !state.nil? && !state[0].nil?
     matched_cities = City.where(:state_code => state[0].state_code)
   end
   render :json => {"matched_cities" => matched_cities}
 end
 
 def get_users_to_msg
   Rails.logger.debug(params[:interest] == "1")
   Rails.logger.debug(current_user.user_type)
   if(params[:interest] != "-1")
    if(current_user.user_type == 1)
      users = User.where(:user_type => 2, :interest => params[:interest])
    else
      users = User.where(:user_type => 1, :interest => params[:interest])
    end 
   else
    if(current_user.user_type == 1)
      users = User.where(:user_type => 2)
    else
      users = User.where(:user_type => 1)
    end      
   end
   render :json => {"matched_users" => users}
 end
 
 def review_rating
   job = Job.where("id=#{params[:job_id]}")
   
   if current_user.user_type == 1
     if(!job.nil? && !job[0].nil? && job[0].is_brand_reviewed == 1)
       redirect_to dashboard_url
       return
     end      
     @user_id = Job.find(params[:job_id]).job_user_id
     if(!job.nil? && !job[0].nil? && job[0].is_reviewed.nil?)
      
       Job.update_all({:is_reviewed => 1}, {:id => params[:job_id]})
       brand = User.find(current_user.id)
       brand_full_name = "#{brand.first_name} #{brand.last_name}"
       presenter = User.find(@user_id)
       presenter_full_name = "#{presenter.first_name} #{presenter.last_name}"
      #-------------- Balanced Payment ----------------
       if(!job[0]['assigned_to'].nil?)
         job_proposal_details = UserJobProposal.find(job[0]['assigned_to'])
         if(!job_proposal_details.nil?)
           proposal_cost = job_proposal_details.proposal_cost
           puts "PROPOSAL COST ------------------------------------------"
           puts proposal_cost
          begin
            Balanced.configure(APP_CONFIG['balanced_secret'])
            customer = Balanced::Customer.find(presenter.balanced_customer_uri)
            amount_in_cents = (proposal_cost.to_i * 88).to_s
            credit = customer.credit(:amount => amount_in_cents,
                           :appears_on_statement_as => 'Brandslip Payment'
                           )
            Transaction.create(:transaction_type => 1,
                               :amount => proposal_cost,
                               :uri => credit.uri
                              )
            flash[:alert] = "Presenter(#{presenter.email}) successfully paid out $#{params['amount']}"
          rescue => e
            flash[:error] = "There was an error processing your payout: #{e.message}"
          end
           Rails.logger.debug("+++Here we get Proposal COST - #{proposal_cost}")
           #Here Ryan can add his payment part and "proposal_cost" variable used as Job accepted proposal cost for charge the presenter card.
         end
       end
       #################################################      
       UserMailer.brand_mark_done_notification(presenter.email,brand_full_name, presenter_full_name).deliver       
     end
   else
     @user_id = UserJobProposal.find(params[:to_user]).user_id
#     job = Job.where("id=#{params[:job_id]}")
#     Job.update_all({:is_presenter_reviewed => 1}, {:id => params[:job_id]})
     Rails.logger.debug("#{job[0].is_presenter_reviewed} --------- #{job[0].is_presenter_reviewed == 1}")
     if(!job.nil? && !job[0].nil? && job[0].is_presenter_reviewed == 1)
       redirect_to dashboard_url
       return
     end 

     if(!job.nil? && !job[0].nil? && job[0].is_reviewed != 1)
       Job.update_all({:is_mark_done => 1, :comment => params[:comment], :video => params[:video]}, {:id => params[:job_id]})
       brand = User.find(@user_id)
       brand_full_name = "#{brand.first_name} #{brand.last_name}"
       presenter = User.find(current_user.id)
       presenter_full_name = "#{presenter.first_name} #{presenter.last_name}"      
       UserMailer.presenter_mark_done_notification(brand.email,brand_full_name, presenter_full_name).deliver
     end
     
     if(!job.nil? && !job[0].nil? && job[0].is_reviewed.nil?)
       redirect_to "/user_job_detail/#{params[:job_id]}"
       return
     end
   end
   
   @to_user = User.find(@user_id).first_name
   @job_title = Job.find(params[:job_id]).job_title
 end
 
 
 def suggestion_review_rating
   suggestion = BrandslipSuggestion.where("id=#{params[:suggestion_id]}")
   
   if current_user.user_type == 1
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_brand_reviewed == 1)
       redirect_to dashboard_url
       return
     end      
     @user_id = UserSuggestionProposal.find(params[:to_user]).user_id
     Rails.logger.debug("@user_id - #{@user_id}")
#     suggestion = BrandslipSuggestion.where("id=#{params[:suggestion_id]}")
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_reviewed.nil?)
       BrandslipSuggestion.update_all({:is_reviewed => 1}, {:id => params[:suggestion_id]})
       brand = User.find(current_user.id)
       brand_full_name = "#{brand.first_name} #{brand.last_name}"
       Rails.logger.debug("brand_full_name - #{brand_full_name}")
       presenter = User.find(@user_id)
       presenter_full_name = "#{presenter.first_name} #{presenter.last_name}"  
       Rails.logger.debug("presenter_full_name - #{presenter_full_name}")
       UserMailer.brand_mark_done_notification(presenter.email,brand_full_name, presenter_full_name).deliver       
     end
   else
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_presenter_reviewed == 1)
       redirect_to dashboard_url
       return
     end  
     @user_id = BrandslipSuggestion.find(params[:suggestion_id]).user_id
#     suggestion = BrandslipSuggestion.where("id=#{params[:suggestion_id]}")
#     BrandslipSuggestion.update_all({:is_presenter_reviewed => 1}, {:id => params[:suggestion_id]})
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_reviewed != 1)
       BrandslipSuggestion.update_all({:is_mark_done => 1, :comment => params[:comment], :video => params[:video]}, {:id => params[:suggestion_id]})
       brand = User.find(@user_id)
       brand_full_name = "#{brand.first_name} #{brand.last_name}"
       presenter = User.find(current_user.id)
       presenter_full_name = "#{presenter.first_name} #{presenter.last_name}"      
       UserMailer.presenter_mark_done_notification(brand.email,brand_full_name, presenter_full_name).deliver
     end
     
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_reviewed.nil?)
       redirect_to "/user_suggestion_detail/#{params[:suggestion_id]}"
       return
     end
   end
   
   @to_user = User.find(@user_id).first_name
   @suggestion_title = BrandslipSuggestion.find(params[:suggestion_id]).title
 end 
 
 def add_review_rating
   job = Job.where("id=#{params[:job_id]}")
   if current_user.user_type == 1
     if(!job.nil? && !job[0].nil? && job[0].is_brand_reviewed == 1)
       render :json => {"success" => false}  
     end    
   else
     if(!job.nil? && !job[0].nil? && job[0].is_presenter_reviewed == 1)
       render :json => {"success" => false}  
     end      
   end
   
  if current_user.user_type == 1
    Job.update_all({:is_brand_reviewed => 1}, {:id => params[:job_id]})
  else
    Job.update_all({:is_presenter_reviewed => 1}, {:id => params[:job_id]})
  end 
  rating = (!params[:entity]['score'].nil? && !params[:entity]['score'].empty?) ? params[:entity]['score'].to_f : 0.00
  user_rating = UserRating.new(:from_user => current_user.id, :to_user => params[:to_user], 
                               :job_id => params[:job_id], :rating => rating, :review => params[:review_comment])
  
  user_rating.save                             
  render :json => {"success" => true}  
 end
 
 def add_suggestion_review_rating
  
  suggestion = BrandslipSuggestion.where("id=#{params[:suggestion_id]}")
  if current_user.user_type == 1
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_brand_reviewed == 1)
       render :json => {"success" => false}  
       return
     end        
  else
     if(!suggestion.nil? && !suggestion[0].nil? && suggestion[0].is_presenter_reviewed == 1)
       render :json => {"success" => false}  
       return
     end     
  end
  if current_user.user_type == 1
    BrandslipSuggestion.update_all({:is_brand_reviewed => 1}, {:id => params[:suggestion_id]})
  else
    BrandslipSuggestion.update_all({:is_presenter_reviewed => 1}, {:id => params[:suggestion_id]})
  end    
  rating = (!params[:entity]['score'].nil? && !params[:entity]['score'].empty?) ? params[:entity]['score'].to_f : 0.00
  user_rating = UserRating.new(:from_user => current_user.id, :to_user => params[:to_user], 
                               :suggestion_id => params[:suggestion_id], :rating => rating, :review => params[:review_comment])
  
 user_rating.save                             
  render :json => {"success" => true}  
   
 end
 
 def faq
   
 end

def get_in_touch
 name=params[:name]
 email=params[:email]
 comment=params[:comment]
 UserMailer.get_in_touch(email,comment,name).deliver


end

 def policies
   
 end
 
 def our_team
   
 end
 
 def terms_conditions
   
 end
 
 def contact_us_page
   @contact_u = ContactU.new
 end
 
 def review
    ratings = UserRating.where(:to_user => current_user.id)
    total_ratings = 0.00
    ratings.each do |rating|
        total_ratings = total_ratings + rating.rating.to_f if !rating.rating.nil?
    end
    @avg_rating = 0
    if(ratings.size > 0)
      @avg_rating = (total_ratings/ratings.size).to_f
    end
    @users = User.find(current_user.id) 
    @brands = User.where(:user_type => 1).reject{ |user| user.balanced_customer_uri.nil? }
    @presenters = User.where(:user_type => 2).reject{ |user| user.balanced_customer_uri.nil? }
 end
 
 def transaction_history
    @brandslips=UserRating.all
 end
 
 def j_save_as_interested
   interested_job = InterestedJobs.new(:user_id => current_user.id, :job_id => params[:job_id])
   interested_job.save
   render :json => {}
 end
 
 def j_remove_from_interested
   InterestedJobs.delete_all(:user_id => current_user.id, :job_id => params[:job_id])
   render :json => {}
 end
 
 def s_save_as_interested
   interested_suggestion = InterestedSuggestions.new(:user_id => current_user.id, :suggestion_id => params[:suggestion_id])
   interested_suggestion.save
   render :json => {}
 end
 
 def s_remove_from_interested
   InterestedSuggestions.delete_all(:user_id => current_user.id, :suggestion_id => params[:suggestion_id])
   render :json => {}
 end
 
 def interested_brandslips
  
   @interested_brandslips = InterestedJobs.where(:user_id => current_user.id)
 end
 
 def interested_suggestions
   @interested_suggestions = InterestedSuggestions.where(:user_id => current_user.id)
 end
 
 def delete_interest_brandslip 
   InterestedJobs.delete_all(:job_id => params[:job_id])
   render :json => {}
 end
 
 def delete_interest_suggestion
   InterestedSuggestions.delete_all(:suggestion_id => params[:suggestion_id])
   render :json => {}
 end
 
  
  def remove_account_user
    @user= current_user
    @user.balanced_customer_uri=nil
    if @user.save
      redirect_to edit_profile1_path
    end  

  end
end

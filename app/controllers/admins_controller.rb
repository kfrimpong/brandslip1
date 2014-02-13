class AdminsController < ApplicationController
#  before_filter :authenticate, :except => [:admin_login, :admin_authentication]
  #layout "admin_layout", :except => [:admin_login]  
  layout "superadmin_layout", :except => [:login]  
  
  def authenticate
    if session[:admin].nil?
      #unauthorized access
      Rails.logger.debug("Session expired.......")
      redirect_to login_admin_path
    end
  end
  
  def login
    
  end
  
  def create_login
    if(params[:admin_email] == 'kofi@gmail.com' && params[:admin_password] == "kofi123")
      session[:admin] = '1'
      redirect_to manage_users_admin_path
    else
      respond_to do| format |
        format.html { redirect_to login_admin_path, notice: 'Invalid username or Password'}
      end      
    end
    
  end
  
  def manage_users
    @users = User.all
  end

  def manage_posts    
    @posts = Job.all
  end
  def manage_suggested_posts
    @suggested_posts = BrandslipSuggestion.all
  end

  def manage_bids    
    @bids = UserJobProposal.all
  end

  def manage_suggestion_bids    
    @suggestion_bids = UserSuggestionProposal.all
  end

  def manage_transactions
    @users = User.all
  end

  def manage_reviews
    @ratings = UserRating.all
  end

  def statistics
    @total_messages = UserMessage.all.count
    @total_feeds = Ribbit.all.count
    @total_reviews = UserRating.all.count
    @total_posts = Job.all.count
    @total_suggested_posts = BrandslipSuggestion.all.count
    @total_bids = UserJobProposal.all.count
    @total_suggested_bids = UserSuggestionProposal.all.count
    @avg_starting_bid = UserJobProposal.average('proposal_cost') 
  end

  def payments
    @transactions = Transaction.all
  end

  def get_weekly_online_posts
    respond_to do |format|

      cur_time = Time.now
      pre_time = cur_time - 1.month
      min_time = Time.new(pre_time.year, pre_time.month, 1)
      next_time = cur_time + 1.month      
      max_time = Time.new(next_time.year, next_time.month, 1)
      @number_online_posts = BrandslipSuggestion.select("week(created_at) as week, count(id) as value").group("week(created_at)").where(["created_at >= ? and created_at <= ? ", min_time, max_time]).order("week")
      @cats = []
      @number_posts = []
      (1..Time.days_in_month(cur_time.month)).each do |week|
        @cats[week] = week.to_s
        @number_posts << '0'
      end      
      
      @number_online_posts.each do |post|
        @number_posts[post.week.to_i] = post.value.to_i
      end

      # Generate test data , pls comment on live
      # @number_posts = []
      # (1..Time.days_in_month(cur_time.month)).each do |day|
      #   @number_posts << rand(1..200)  
      # end  
      

      format.json { render json: {:posts=>@number_posts,:cats=>@cats, :year =>cur_time.year, :month=>cur_time.month } }
    end
  end

  def get_monthly_online_posts
    respond_to do |format|

      cur_time = Time.now      
      min_time = Time.new(cur_time.year, 1, 1)      
      max_time = Time.new(cur_time.year, 12, 31)
      @number_online_posts = BrandslipSuggestion.select("month(created_at) as month, count(id) as value").group("month(created_at)").where(["created_at >= ? and created_at <= ? ", min_time, max_time]).order("month")
      @cats = []
      @number_posts = []
      (1..12).each do |month|
        @cats[month-1] = month.to_s
        @number_posts << '0'
      end
      
      @number_online_posts.each do |post|
        @number_posts[post.month.to_i] = post.value.to_i
      end

      # Generate test data , pls comment on live
      # @number_posts = []
      # (1..12).each do |day|
      #   @number_posts << rand(1..200)  
      # end  
      

      format.json { render json: {:posts=>@number_posts,:cats=>@cats, :year =>cur_time.year } }
    end
  end  

  def get_daily_online_posts
    respond_to do |format|

      cur_time = Time.now
      min_time = Time.new(cur_time.year, cur_time.month, 1)
      next_time = min_time + 1.month      
      max_time = Time.new(next_time.year, next_time.month, 1)
      @number_online_posts = BrandslipSuggestion.select("day(created_at) as day, count(id) as value").group("date(created_at)").where(["created_at >= ? and created_at <= ? ", min_time, max_time]).order("day")
      @cats = []
      @number_posts = []
      (1..Time.days_in_month(cur_time.month)).each do |day|
        @cats[day-1] = day.to_s
        @number_posts << '0'
      end      
      
      @number_online_posts.each do |post|
        @number_posts[post.day.to_i] = post.value.to_i
      end

      # Generate test data , pls comment on live
      # @number_posts = []
      # (1..Time.days_in_month(cur_time.month)).each do |day|
      #   @number_posts << rand(1..200)  
      # end 

      format.json { render json: {:posts=>@number_posts,:cats=>@cats, :year =>cur_time.year, :month=>cur_time.month } }
    end    
  end

  def logout
    session[:admin] = nil
    redirect_to login_admin_path
  end
  
  def action_on_selected_user
    Rails.logger.debug(params[:user_id])
    Rails.logger.debug(params[:is_approved])
    
    params[:user_id].each do |user_id|
      Rails.logger.debug("-----------------------")
      Rails.logger.debug(user_id)
      user = User.find(user_id)
      if !user.nil?
        action = ""
        if params[:is_approved]== '1' || params[:is_approved] == 1
          if !user.confirmed?
            user.confirm!
          end
          action = "Approved"
          full_name = "#{user.first_name} #{user.last_name}"
          UserMailer.approve_notification(user.email,full_name, action).deliver
        end
        User.update_all({:is_approved => params[:is_approved]}, {:id => user_id})
      end
      
    end
    render :json => {}
    
  end

  def delete_selected_user    
        
    params[:user_id].each do |user_id|
      Rails.logger.debug("-----------------------")
      Rails.logger.debug(user_id)
      user = User.find(user_id)
      if !user.nil?
        
        user.destroy
      end
    end
    render :json => {}
    
  end

  def delete_selected_posts
    params[:post_ids].each do |post_id|      
      job = Job.find(post_id)
      if !job.nil?
        job.destroy
      end
    end
    render :json => {}    
  end

  def delete_selected_suggested_posts
    params[:post_ids].each do |post_id|      
      sug = BrandslipSuggestion.find(post_id)
      if !sug.nil?
        sug.destroy
      end
    end
    render :json => {}        
  end

  def delete_selected_bids
    params[:bid_ids].each do |bid_id|      
      bid = UserJobProposal.find(bid_id)
      if !bid.nil?
        bid.destroy
      end
    end
    render :json => {}    
  end
  def delete_selected_suggestion_bids
    params[:bid_ids].each do |bid_id|      
      bid = UserSuggestionProposal.find(bid_id)
      if !bid.nil?
        bid.destroy
      end
    end
    render :json => {}    
  end
  def delete_selected_reviews
    params[:review_ids].each do |bid_id|      
      bid = UserRating.find(bid_id)
      if !bid.nil?
        bid.destroy
      end
    end
    render :json => {}        
  end

end




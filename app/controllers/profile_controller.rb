class ProfileController < ApplicationController
  layout 'profile'
  def brands_profile
    @brands_users = User.where(:user_type => 1)
  end
  
  def presenters_profile
    
    @presenters_users = User.where(:user_type => 2)
  end
  
  def search_profile_filter
    sub_category_clause = ""
    if(params[:demographic_arr].include? "-1")
      sub_category_clause = ""
    else
      sub_category_clause += "and ("
      subcategory_size_length = params[:demographic_arr].length
      index = 0
      params[:demographic_arr].each do |sub_category|
        if((index + 1) == subcategory_size_length)
          sub_category_clause += " sub_category='#{sub_category}' "
        else
          sub_category_clause += " sub_category='#{sub_category}' or "
        end
        index = index + 1
      end
      sub_category_clause += ") "
    end    
    
    online_source_clause = ""
    if(params[:online_source_arr].include? "-1")
      online_source_clause = ""
    else
      online_source_clause += "and ("
      online_source_size_length = params[:online_source_arr].length
      index = 0
      params[:online_source_arr].each do |source|
        if((index + 1) == online_source_size_length)
          online_source_clause += " (#{source} is not null and length(#{source})>1) "
        else
          online_source_clause += " (#{source} is not null and length(#{source})>1) or "
        end
        index = index + 1
      end
      online_source_clause += ") "
    end    
    
    follower_subscriber_clause = ""
    if(params[:followers_subscribers_arr].include? "-1")
      follower_subscriber_clause = ""
    else
      follower_subscriber_clause += "and ("
      follower_subscriber_size_length = params[:followers_subscribers_arr].length
      index = 0
      params[:followers_subscribers_arr].each do |f_s|
        if((index + 1) == follower_subscriber_size_length)
          follower_subscriber_clause += " (youtube_subscribers='#{f_s}' or vine_followers='#{f_s}' or instagram_followers='#{f_s}' or snapchat_followers='#{f_s}') "
        else
          follower_subscriber_clause += " (youtube_subscribers='#{f_s}' or vine_followers='#{f_s}' or instagram_followers='#{f_s}' or snapchat_followers='#{f_s}') or "
        end
        index = index + 1
      end
      follower_subscriber_clause += ") "
    end   
    
    if(params[:category_arr].include? "-1")
      @presenters = User.find_by_sql("select * from users where user_type=2 and is_approved=1 #{sub_category_clause} #{online_source_clause} #{follower_subscriber_clause}")
    else
      category_str = params[:category_arr].join(",")
      @presenters = User.find_by_sql("select * from users where user_type=2 and is_approved=1 and interest in (#{category_str}) #{sub_category_clause} #{online_source_clause} #{follower_subscriber_clause}")
    end
    render :template => "brandslip/_presenter_profile", :layout => false
  end
  
  def search_brand_filter
    sub_category_clause = ""
    if(params[:demographic_arr].include? "-1")
      sub_category_clause = ""
    else
      sub_category_clause += "and ("
      subcategory_size_length = params[:demographic_arr].length
      index = 0
      params[:demographic_arr].each do |sub_category|
        if((index + 1) == subcategory_size_length)
          sub_category_clause += " sub_category='#{sub_category}' "
        else
          sub_category_clause += " sub_category='#{sub_category}' or "
        end
        index = index + 1
      end
      sub_category_clause += ") "
    end  
    
    online_source_clause = ""
    if(params[:online_source_arr].include? "-1")
      online_source_clause = ""
    else
      online_source_clause += "and ("
      online_source_size_length = params[:online_source_arr].length
      index = 0
      params[:online_source_arr].each do |source|
        if((index + 1) == online_source_size_length)
          online_source_clause += " (#{source} is not null and length(#{source})>1) "
        else
          online_source_clause += " (#{source} is not null and length(#{source})>1) or "
        end
        index = index + 1
      end
      online_source_clause += ") "
    end  
    
    follower_subscriber_clause = ""
    if(params[:followers_subscribers_arr].include? "-1")
      follower_subscriber_clause = ""
    else
      follower_subscriber_clause += "and ("
      follower_subscriber_size_length = params[:followers_subscribers_arr].length
      index = 0
      params[:followers_subscribers_arr].each do |f_s|
        if((index + 1) == follower_subscriber_size_length)
          follower_subscriber_clause += " (youtube_subscribers='#{f_s}' or vine_followers='#{f_s}' or instagram_followers='#{f_s}' or snapchat_followers='#{f_s}') "
        else
          follower_subscriber_clause += " (youtube_subscribers='#{f_s}' or vine_followers='#{f_s}' or instagram_followers='#{f_s}' or snapchat_followers='#{f_s}') or "
        end
        index = index + 1
      end
      follower_subscriber_clause += ") "
    end     
    
    
    if(params[:category_arr].include? "-1")
      @brands = User.find_by_sql("select * from users where user_type=1 and is_approved=1 #{sub_category_clause} #{online_source_clause} #{follower_subscriber_clause}")
    else
      category_str = params[:category_arr].join(",")
      @brands = User.find_by_sql("select * from users where user_type=1 and is_approved=1 and interest in (#{category_str}) #{sub_category_clause} #{online_source_clause} #{follower_subscriber_clause}")
    end
    render :template => "brandslip/_brand_profile", :layout => false
  end
  
 def presenters_profile_show

  ratings = UserRating.where(:to_user => params[:id])
  total_ratings = 0.00
  ratings.each do |rating|
      total_ratings = total_ratings + rating.rating.to_f if !rating.rating.nil?
  end
  @avg_rating = 0
  if(ratings.size > 0)
    @avg_rating = (total_ratings/ratings.size).to_f
  end    
  @user = User.find(params[:id])
  @reviews = UserRating.where(:to_user => @user.id)
  @relationship = Relationship.new
 end
 
 def brands_profile_show
  
  ratings = UserRating.where(:to_user => params[:id])
  total_ratings = 0.00
  ratings.each do |rating|
      total_ratings = total_ratings + rating.rating.to_f if !rating.rating.nil?
  end
  @avg_rating = 0
  if(ratings.size > 0)
    @avg_rating = (total_ratings/ratings.size).to_f
  end 
  @user = User.find(params[:id])
  @reviews = UserRating.where(:to_user => @user.id)
  @relationship = Relationship.new
 end  
  
end

class RelationshipsController < ApplicationController
  def create
    @relationship = Relationship.new
    @relationship.followed_id = params[:followed_id]
    @relationship.follower_id = current_user.id

    if @relationship.save
      if(current_user.user_type == 1)
        redirect_to presenters_profile_show_path(:id => params[:followed_id])
      else
        redirect_to brands_profile_show_path(:id => params[:followed_id])
      end
    else
        flash[:error] = "Couldn't Follow"
        redirect_to root_url
    end
  end  
  
#  def destroy
#      @relationship = Relationship.find(params[:id])
#      @relationship.destroy
#      redirect_to user_path params[:id]
#  end  
  
  def unfollow
      @relationship = Relationship.where(:followed_id => params[:followed_id], :follower_id => params[:follower_id])
      @relationship[0].destroy
      if(current_user.user_type == 1)
        redirect_to presenters_profile_show_path(:id => params[:followed_id])
      else
        redirect_to brands_profile_show_path(:id => params[:followed_id])
      end
  end  
end

class BrandslipSuggestionsController < ApplicationController
  layout "brandslip_layout"
  before_filter :is_profile_complete

  # GET /brandslip_suggestions/1
  # GET /brandslip_suggestions/1.json
  def show
    @brandslip_suggestion = BrandslipSuggestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @brandslip_suggestion }
    end
  end

  # GET /brandslip_suggestions/new
  # GET /brandslip_suggestions/new.json
  def new
    if !current_user.balanced_customer_uri.nil?
    @brandslip_suggestion = BrandslipSuggestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @brandslip_suggestion }
    end
    else
      session[:return_to]="new_suggestion"
    redirect_to root_path
  end
  end

  # GET /brandslip_suggestions/1/edit
  def edit
    @brandslip_suggestion = BrandslipSuggestion.find(params[:id])
  end

  # POST /brandslip_suggestions
  # POST /brandslip_suggestions.json
  def create
    @brandslip_suggestion = BrandslipSuggestion.new(params[:brandslip_suggestion])
     
    respond_to do |format|
      if @brandslip_suggestion.save
        ribbit = Ribbit.new(:user_id => current_user.id, :content => "#{@brandslip_suggestion.title}")
        ribbit.save
        user_name = User.find(current_user.id).first_name
        user_email = User.find(current_user.id).email
        UserMailer.notifier_suggestion(user_name, user_email, params[:brandslip_suggestion][:title]).deliver
        format.html { redirect_to @brandslip_suggestion, notice: 'Brandslip suggestion was successfully created.' }
        format.json { render json: @brandslip_suggestion, status: :created, location: @brandslip_suggestion }
      else
        format.html { render action: "new" }
        format.json { render json: @brandslip_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /brandslip_suggestions/1
  # PUT /brandslip_suggestions/1.json
  def update
    @brandslip_suggestion = BrandslipSuggestion.find(params[:id])

    respond_to do |format|
      if @brandslip_suggestion.update_attributes(params[:brandslip_suggestion])
        format.html { redirect_to @brandslip_suggestion, notice: 'Brandslip suggestion was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @brandslip_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /brandslip_suggestions/1
  # DELETE /brandslip_suggestions/1.json
  def destroy
    @brandslip_suggestion = BrandslipSuggestion.find(params[:id])
    @brandslip_suggestion.destroy

    respond_to do |format|
      format.html { redirect_to brandslip_suggestions_url }
      format.json { head :no_content }
    end
  end
  
  def delete_suggestion
   Rails.logger.debug("#{params[:suggestion_id]}")
   
   @presenter = BrandslipSuggestion.find(params[:suggestion_id])
   BrandslipSuggestion.delete_all("id=#{params[:suggestion_id]}")
   
  @delete_suggestion_notifications = UserSuggestionProposal.find_by_sql("select distinct user_id from user_suggestion_proposals where suggestion_id=#{params[:suggestion_id]}")
  @delete_suggestion_notifications.each do |suggestion|
#     presenter = Job.find(params[:job_id])
    presenter_user = User.where(:id => @presenter.user_id)
    presenter_full_name = "#{presenter_user[0].first_name} #{presenter_user[0].last_name}"
    user = User.where(:id => suggestion.user_id)
    brand_full_name = "#{user[0].first_name} #{user[0].last_name}"
    
    UserMailer.delete_suggestion_notification(user[0].email,brand_full_name, presenter_full_name, @presenter.title).deliver
  end        
  UserSuggestionProposal.delete_all("suggestion_id=#{params[:suggestion_id]}")
   render :json => {}
  end  
end

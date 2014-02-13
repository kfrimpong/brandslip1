class JobsController < ApplicationController
  layout "brandslip_layout"
  before_filter :is_profile_complete
  
  # GET /jobs
  # GET /jobs.json
#  def index
#    @jobs = Job.all
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.json { render json: @jobs }
#    end
#  end

  # GET /jobs/1
  # GET /jobs/1.json
  def show
    @job = Job.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @job }
    end
  end

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    if !current_user.balanced_customer_uri.nil?
    @job = Job.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job }
    end
   else
     session[:new_value_job]="new_job_edit_profile"
     redirect_to root_path
   end
  end

  # GET /jobs/1/edit
  def edit
    @job = Job.find(params[:id])
  end

  # POST /jobs
  # POST /jobs.json
  def create
    
    @job = Job.new(params[:job])
    respond_to do |format|
      if @job.save
        ribbit = Ribbit.new(:user_id => current_user.id, :content => "#{@job.job_title}")
        ribbit.save
        user_name = User.find(current_user.id).first_name
        user_email = User.find(current_user.id).email
        UserMailer.notifier(user_name, user_email, params[:job][:job_title]).deliver
        format.html { redirect_to @job, notice: 'Job was successfully created.' }
        format.json { render json: @job, status: :created, location: @job }
      else
        format.html { render action: "new" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /jobs/1
  # PUT /jobs/1.json
  def update
    @job = Job.find(params[:id])

    respond_to do |format|
      if @job.update_attributes(params[:job])
        format.html { redirect_to @job, notice: 'Job was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job = Job.find(params[:id])
    @job.destroy

    respond_to do |format|
      format.html { redirect_to jobs_url }
      format.json { head :no_content }
    end
  end
  
  def delete_job
  
   Rails.logger.debug("#{params[:job_id]}")
   @presenter = Job.find(params[:job_id])
    Job.delete_all("id=#{params[:job_id]}")
   
   @delete_job_notifications = UserJobProposal.find_by_sql("select distinct user_id from user_job_proposals where job_id=#{params[:job_id]}")
   @delete_job_notifications.each do |job|
    
     #presenter = Job.find(params[:job_id])
     presenter_user = User.where(:id => @presenter.job_user_id)
     presenter_full_name = "#{presenter_user[0].first_name} #{presenter_user[0].last_name}"
     user = User.where(:id => job.user_id)
     brand_full_name = "#{user[0].first_name} #{user[0].last_name}"
     UserMailer.delete_job_notification(user[0].email,brand_full_name, presenter_full_name, @presenter.job_title).deliver
   
   end 
          
   UserJobProposal.delete_all("job_id=#{params[:job_id]}")
   
   render :json => {}
  end
 



end

class UserJobProposalsController < ApplicationController
  # GET /user_job_proposals
  # GET /user_job_proposals.json
  layout "brandslip_layout", :only => [:show]
  def index
    @user_job_proposals = UserJobProposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_job_proposals }
    end
  end

  # GET /user_job_proposals/1
  # GET /user_job_proposals/1.json
  def show
    @user_job_proposal = UserJobProposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_job_proposal }
    end
  end

  # GET /user_job_proposals/new
  # GET /user_job_proposals/new.json
  def new
    @user_job_proposal = UserJobProposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_job_proposal }
    end
  end

  # GET /user_job_proposals/1/edit
  def edit
    @user_job_proposal = UserJobProposal.find(params[:id])
  end

  # POST /user_job_proposals
  # POST /user_job_proposals.json
  def create
    
    @user_job_proposal = UserJobProposal.new(params[:user_job_proposal])
    job_user_name = User.find(params[:user_job_proposal][:user_id]).first_name
    #proposal_user_name = User.find(current_user.id).first_name
    #job_user_email = User.find(params[:user_job_proposal][:user_id]).email
    job_details = Job.find(params[:user_job_proposal][:job_id])
    proposal_details = params[:user_job_proposal]

    proposal_user_name = User.find(job_details.job_user_id).first_name
    job_user_email = User.find(job_details.job_user_id).email
    UserMailer.proposal_job_notifier(job_user_name, proposal_user_name, job_user_email, job_details, proposal_details).deliver
    respond_to do |format|
      if @user_job_proposal.save  
        format.html { redirect_to @user_job_proposal, notice: 'Your proposal was successfully created.' }
        format.json { render json: @user_job_proposal, status: :created, location: @user_job_proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @user_job_proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_job_proposals/1
  # PUT /user_job_proposals/1.json
  def update
    @user_job_proposal = UserJobProposal.find(params[:id])

    respond_to do |format|
      if @user_job_proposal.update_attributes(params[:user_job_proposal])
        format.html { redirect_to @user_job_proposal, notice: 'User job proposal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_job_proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_job_proposals/1
  # DELETE /user_job_proposals/1.json
  def destroy
    @user_job_proposal = UserJobProposal.find(params[:id])
    @user_job_proposal.destroy

    respond_to do |format|
      format.html { redirect_to user_job_proposals_url }
      format.json { head :no_content }
    end
  end
end

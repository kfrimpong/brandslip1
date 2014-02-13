class UserSuggestionProposalsController < ApplicationController
  layout "brandslip_layout", :only => [:show]
  # GET /user_suggestion_proposals
  # GET /user_suggestion_proposals.json
  def index
    @user_suggestion_proposals = UserSuggestionProposal.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_suggestion_proposals }
    end
  end

  # GET /user_suggestion_proposals/1
  # GET /user_suggestion_proposals/1.json
  def show
    @user_suggestion_proposal = UserSuggestionProposal.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_suggestion_proposal }
    end
  end

  # GET /user_suggestion_proposals/new
  # GET /user_suggestion_proposals/new.json
  def new
    @user_suggestion_proposal = UserSuggestionProposal.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_suggestion_proposal }
    end
  end

  # GET /user_suggestion_proposals/1/edit
  def edit
    @user_suggestion_proposal = UserSuggestionProposal.find(params[:id])
  end

  # POST /user_suggestion_proposals
  # POST /user_suggestion_proposals.json
  def create
    
    @user_suggestion_proposal = UserSuggestionProposal.new(params[:user_suggestion_proposal])
    suggestion_user_name = User.find(params[:user_suggestion_proposal][:user_id]).first_name   
    suggestion_details = BrandslipSuggestion.find(params[:user_suggestion_proposal][:suggestion_id])
    proposal_details = params[:user_suggestion_proposal]
    proposal_user_name = User.find(suggestion_details.user_id).first_name
    suggestion_user_email = User.find(suggestion_details.user_id).email
    UserMailer.proposal_suggestion_notifier(suggestion_user_name, proposal_user_name, suggestion_user_email, suggestion_details, proposal_details).deliver
    respond_to do |format|
      if @user_suggestion_proposal.save
        format.html { redirect_to @user_suggestion_proposal, notice: 'Your proposal was successfully created.' }
        format.json { render json: @user_suggestion_proposal, status: :created, location: @user_suggestion_proposal }
      else
        format.html { render action: "new" }
        format.json { render json: @user_suggestion_proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_suggestion_proposals/1
  # PUT /user_suggestion_proposals/1.json
  def update
    @user_suggestion_proposal = UserSuggestionProposal.find(params[:id])

    respond_to do |format|
      if @user_suggestion_proposal.update_attributes(params[:user_suggestion_proposal])
        format.html { redirect_to @user_suggestion_proposal, notice: 'User suggestion proposal was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_suggestion_proposal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_suggestion_proposals/1
  # DELETE /user_suggestion_proposals/1.json
  def destroy
    @user_suggestion_proposal = UserSuggestionProposal.find(params[:id])
    @user_suggestion_proposal.destroy

    respond_to do |format|
      format.html { redirect_to user_suggestion_proposals_url }
      format.json { head :no_content }
    end
  end
end

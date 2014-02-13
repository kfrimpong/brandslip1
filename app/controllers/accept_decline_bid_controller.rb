class AcceptDeclineBidController < ApplicationController
 def accept_bid
  # balanced payment stuff ####
 
  proposal = UserJobProposal.find(params[:bid_id])
  brand_id = proposal.user_id
  balanced_job = Job.find(params[:job_id])
  presenter_id = balanced_job.job_user_id
  @brand = User.find(brand_id)
  @presenter = User.find(presenter_id)
  begin
    Balanced.configure(APP_CONFIG['balanced_secret'])
    customer = Balanced::Customer.find(@brand.balanced_customer_uri)
    amount_in_cents = (proposal.proposal_cost.to_i * 100).to_s
    debit = customer.debit(:amount => amount_in_cents,:appears_on_statement_as => 'Brandslip Payment',:on_behalf_of_uri => @presenter.balanced_customer_uri)
    Transaction.create(:transaction_type => 0,
                       :amount => proposal.proposal_cost.to_i,
                       :uri => debit.uri,
                       :debitted_id => @brand.id,
                       :creditted_id => @presenter.id
                      )
    flash[:alert] = "Brand(#{@brand.email}) successfully charged $#{proposal.proposal_cost} on behalf of #{@presenter.email}"
  rescue Exception => e
    flash[:error] = "There was an error processing your charge: #{e.message}"
  end

  #############################
  Rails.logger.debug(params[:bid_id])
  Job.update_all({:is_assigned => 1, :assigned_to => params[:bid_id]}, {:id => params[:job_id]})
  @job_details = Job.where(:id => params[:job_id])
  rejected_proposals = UserJobProposal.find_by_sql("select * from user_job_proposals where job_id=#{params[:job_id]} and id!=#{params[:bid_id]}")
  rejected_proposals.each do |bid|
     job = Job.find(bid.job_id)
     user = User.find(bid.user_id)
     if(!user.nil? && !job.nil?)
       full_name = "#{user.first_name} #{user.last_name}"
       UserMailer.decline_bid_notification(user.email,full_name, job.job_title).deliver
       UserJobProposal.delete_all("id=#{bid.id}")
     else
       Rails.logger.debug("XXXX Job or user not found while declined proposal - #{params[:bid_id]}....")
     end    
  end
  @users_applied_for_job = UserJobProposal.where(:id => params[:bid_id])
  @users_applied_for_job.each do |proposal|
    job = Job.find(proposal.job_id)
    user = User.where(:id => proposal.user_id)
    full_name = "#{user[0].first_name} #{user[0].last_name}"
    UserMailer.accept_bid_notification(user[0].email,full_name, job.job_title).deliver
    proposal["user_name"] = user[0]['first_name']
  end 
  sleep 1 
  render "brandslip/_brands_bid", :layout => false
 end
 
 def delete_bid
   Rails.logger.debug(params[:bid_id])
   job_proposal = UserJobProposal.find(params[:bid_id])
   if(!job_proposal.nil? && !job_proposal.job_id.nil? && !job_proposal.user_id.nil?)
     Rails.logger.debug "XXXX Declined job - #{job_proposal.job_id} for user - #{job_proposal.user_id}"
     job = Job.find(job_proposal.job_id)
     user = User.find(job_proposal.user_id)
     if(!user.nil? && !job.nil?)
       full_name = "#{user.first_name} #{user.last_name}"
       UserMailer.decline_bid_notification(user.email,full_name, job.job_title).deliver
       UserJobProposal.delete_all("id=#{params[:bid_id]}")
     else
       Rails.logger.debug("XXXX Job or user not found while declined proposal - #{params[:bid_id]}....")
     end
   else
     Rails.logger.debug("XXXXX Declined job proposal not found....")
   end
   
   render :json => {}
 end 
 
 def accept_suggestion_bid
  
  Rails.logger.debug(params[:bid_id])
  BrandslipSuggestion.update_all({:is_assigned => 1, :assigned_to => params[:bid_id]}, {:id => params[:suggestion_id]})
  @suggestion_details = BrandslipSuggestion.where(:id => params[:suggestion_id])
  rejected_proposals = UserSuggestionProposal.find_by_sql("select * from user_suggestion_proposals where suggestion_id=#{params[:suggestion_id]} and id!=#{params[:bid_id]}")
  rejected_proposals.each do |bid|
     suggestion = BrandslipSuggestion.find(bid.suggestion_id)
     user = User.find(bid.user_id)
     if(!user.nil? && !suggestion.nil?)
       full_name = "#{user.first_name} #{user.last_name}"
       UserMailer.decline_bid_notification(user.email,full_name, suggestion.title).deliver
       UserSuggestionProposal.delete_all("id=#{bid.id}")
     else
       Rails.logger.debug("XXXX Job or user not found while declined proposal - #{params[:bid_id]}....")
     end    
  end
  @users_applied_for_suggestion= UserSuggestionProposal.where(:id => params[:bid_id])
  @users_applied_for_suggestion.each do |proposal|
    suggestion = BrandslipSuggestion.find(proposal.suggestion_id)
    user = User.where(:id => proposal.user_id)
    full_name = "#{user[0].first_name} #{user[0].last_name}"
    UserMailer.accept_bid_notification(user[0].email,full_name, suggestion.title).deliver
    proposal["user_name"] = user[0]['first_name']
  end 
  sleep 1 
  render "brandslip/_presenters_bid", :layout => false
 end
 
 
 def delete_suggestion_bid
   Rails.logger.debug(params[:bid_id])
   suggestion_proposal = UserSuggestionProposal.find(params[:bid_id])
   if(!suggestion_proposal.nil? && !suggestion_proposal.suggestion_id.nil? && !suggestion_proposal.user_id.nil?)
     Rails.logger.debug "XXXX Declined suggestion - #{suggestion_proposal.suggestion_id} for user - #{suggestion_proposal.user_id}"
     suggestion = BrandslipSuggestion.find(suggestion_proposal.suggestion_id)
     user = User.find(suggestion_proposal.user_id)
     if(!user.nil? && !suggestion.nil?)
       full_name = "#{user.first_name} #{user.last_name}"
       UserMailer.decline_bid_notification(user.email,full_name, suggestion.title).deliver
       UserJobProposal.delete_all("id=#{params[:bid_id]}")
     else
       Rails.logger.debug("XXXX Suggestion or user not found while declined proposal - #{params[:bid_id]}....")
     end
   else
     Rails.logger.debug("XXXXX Declined suggestion proposal not found....")
   end
   
   render :json => {}
 end  
 
end

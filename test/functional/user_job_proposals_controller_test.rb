require 'test_helper'

class UserJobProposalsControllerTest < ActionController::TestCase
  setup do
    @user_job_proposal = user_job_proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_job_proposals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_job_proposal" do
    assert_difference('UserJobProposal.count') do
      post :create, user_job_proposal: { estimate_delivery_date: @user_job_proposal.estimate_delivery_date, is_place_mine_at_the_top: @user_job_proposal.is_place_mine_at_the_top, is_submit_later: @user_job_proposal.is_submit_later, job_id: @user_job_proposal.job_id, my_earning: @user_job_proposal.my_earning, proposal_cost: @user_job_proposal.proposal_cost, proposal_details: @user_job_proposal.proposal_details, user_id: @user_job_proposal.user_id }
    end

    assert_redirected_to user_job_proposal_path(assigns(:user_job_proposal))
  end

  test "should show user_job_proposal" do
    get :show, id: @user_job_proposal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_job_proposal
    assert_response :success
  end

  test "should update user_job_proposal" do
    put :update, id: @user_job_proposal, user_job_proposal: { estimate_delivery_date: @user_job_proposal.estimate_delivery_date, is_place_mine_at_the_top: @user_job_proposal.is_place_mine_at_the_top, is_submit_later: @user_job_proposal.is_submit_later, job_id: @user_job_proposal.job_id, my_earning: @user_job_proposal.my_earning, proposal_cost: @user_job_proposal.proposal_cost, proposal_details: @user_job_proposal.proposal_details, user_id: @user_job_proposal.user_id }
    assert_redirected_to user_job_proposal_path(assigns(:user_job_proposal))
  end

  test "should destroy user_job_proposal" do
    assert_difference('UserJobProposal.count', -1) do
      delete :destroy, id: @user_job_proposal
    end

    assert_redirected_to user_job_proposals_path
  end
end

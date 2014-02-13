require 'test_helper'

class UserSuggestionProposalsControllerTest < ActionController::TestCase
  setup do
    @user_suggestion_proposal = user_suggestion_proposals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_suggestion_proposals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_suggestion_proposal" do
    assert_difference('UserSuggestionProposal.count') do
      post :create, user_suggestion_proposal: { proposal_cost: @user_suggestion_proposal.proposal_cost, proposal_details: @user_suggestion_proposal.proposal_details, suggestion_id: @user_suggestion_proposal.suggestion_id, user_id: @user_suggestion_proposal.user_id }
    end

    assert_redirected_to user_suggestion_proposal_path(assigns(:user_suggestion_proposal))
  end

  test "should show user_suggestion_proposal" do
    get :show, id: @user_suggestion_proposal
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_suggestion_proposal
    assert_response :success
  end

  test "should update user_suggestion_proposal" do
    put :update, id: @user_suggestion_proposal, user_suggestion_proposal: { proposal_cost: @user_suggestion_proposal.proposal_cost, proposal_details: @user_suggestion_proposal.proposal_details, suggestion_id: @user_suggestion_proposal.suggestion_id, user_id: @user_suggestion_proposal.user_id }
    assert_redirected_to user_suggestion_proposal_path(assigns(:user_suggestion_proposal))
  end

  test "should destroy user_suggestion_proposal" do
    assert_difference('UserSuggestionProposal.count', -1) do
      delete :destroy, id: @user_suggestion_proposal
    end

    assert_redirected_to user_suggestion_proposals_path
  end
end

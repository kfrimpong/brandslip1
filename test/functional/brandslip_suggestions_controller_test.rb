require 'test_helper'

class BrandslipSuggestionsControllerTest < ActionController::TestCase
  setup do
    @brandslip_suggestion = brandslip_suggestions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:brandslip_suggestions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create brandslip_suggestion" do
    assert_difference('BrandslipSuggestion.count') do
      post :create, brandslip_suggestion: { assigned_to: @brandslip_suggestion.assigned_to, category: @brandslip_suggestion.category, city: @brandslip_suggestion.city, comment: @brandslip_suggestion.comment, crowd_size: @brandslip_suggestion.crowd_size, description: @brandslip_suggestion.description, followers_subscribers: @brandslip_suggestion.followers_subscribers, is_assigned: @brandslip_suggestion.is_assigned, is_mark_done: @brandslip_suggestion.is_mark_done, is_reviewed: @brandslip_suggestion.is_reviewed, online_media_source: @brandslip_suggestion.online_media_source, price: @brandslip_suggestion.price, proof_selector: @brandslip_suggestion.proof_selector, start_date: @brandslip_suggestion.start_date, state: @brandslip_suggestion.state, sub_category: @brandslip_suggestion.sub_category, suggestion_type: @brandslip_suggestion.suggestion_type, time: @brandslip_suggestion.time, title: @brandslip_suggestion.title, user_id: @brandslip_suggestion.user_id, valid_for: @brandslip_suggestion.valid_for, video: @brandslip_suggestion.video }
    end

    assert_redirected_to brandslip_suggestion_path(assigns(:brandslip_suggestion))
  end

  test "should show brandslip_suggestion" do
    get :show, id: @brandslip_suggestion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @brandslip_suggestion
    assert_response :success
  end

  test "should update brandslip_suggestion" do
    put :update, id: @brandslip_suggestion, brandslip_suggestion: { assigned_to: @brandslip_suggestion.assigned_to, category: @brandslip_suggestion.category, city: @brandslip_suggestion.city, comment: @brandslip_suggestion.comment, crowd_size: @brandslip_suggestion.crowd_size, description: @brandslip_suggestion.description, followers_subscribers: @brandslip_suggestion.followers_subscribers, is_assigned: @brandslip_suggestion.is_assigned, is_mark_done: @brandslip_suggestion.is_mark_done, is_reviewed: @brandslip_suggestion.is_reviewed, online_media_source: @brandslip_suggestion.online_media_source, price: @brandslip_suggestion.price, proof_selector: @brandslip_suggestion.proof_selector, start_date: @brandslip_suggestion.start_date, state: @brandslip_suggestion.state, sub_category: @brandslip_suggestion.sub_category, suggestion_type: @brandslip_suggestion.suggestion_type, time: @brandslip_suggestion.time, title: @brandslip_suggestion.title, user_id: @brandslip_suggestion.user_id, valid_for: @brandslip_suggestion.valid_for, video: @brandslip_suggestion.video }
    assert_redirected_to brandslip_suggestion_path(assigns(:brandslip_suggestion))
  end

  test "should destroy brandslip_suggestion" do
    assert_difference('BrandslipSuggestion.count', -1) do
      delete :destroy, id: @brandslip_suggestion
    end

    assert_redirected_to brandslip_suggestions_path
  end
end

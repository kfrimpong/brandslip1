require 'test_helper'

class JobsControllerTest < ActionController::TestCase
  setup do
    @job = jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create job" do
    assert_difference('Job.count') do
      post :create, job: { job_category: @job.job_category, job_description: @job.job_description, job_price_fixed_type: @job.job_price_fixed_type, job_price_hour_range: @job.job_price_hour_range, job_price_type: @job.job_price_type, job_skill: @job.job_skill, job_start_date: @job.job_start_date, job_sub_category: @job.job_sub_category, job_title: @job.job_title, job_valid_for: @job.job_valid_for }
    end

    assert_redirected_to job_path(assigns(:job))
  end

  test "should show job" do
    get :show, id: @job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @job
    assert_response :success
  end

  test "should update job" do
    put :update, id: @job, job: { job_category: @job.job_category, job_description: @job.job_description, job_price_fixed_type: @job.job_price_fixed_type, job_price_hour_range: @job.job_price_hour_range, job_price_type: @job.job_price_type, job_skill: @job.job_skill, job_start_date: @job.job_start_date, job_sub_category: @job.job_sub_category, job_title: @job.job_title, job_valid_for: @job.job_valid_for }
    assert_redirected_to job_path(assigns(:job))
  end

  test "should destroy job" do
    assert_difference('Job.count', -1) do
      delete :destroy, id: @job
    end

    assert_redirected_to jobs_path
  end
end

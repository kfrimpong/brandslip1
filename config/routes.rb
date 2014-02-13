Brandslip::Application.routes.draw do

  resources :user_suggestion_proposals

  resources :brandslip_suggestions

  resources :relationships

  resources :ribbits

  resources :contact_us

  resources :user_job_proposals

  resources :jobs
  
  resource :admin do 
    collection do 
      get 'login'
      post 'create_login'
      get 'logout'
      get 'manage_users'
      get 'manage_posts'
      get 'manage_suggested_posts'      
      get 'manage_bids'
      get 'manage_suggestion_bids'
      get 'manage_reviews'
     
      get 'manage_transactions'
      post 'delete_selected_user'
      post 'delete_selected_posts'
      post 'delete_selected_suggested_posts'
      post 'delete_selected_bids'
      post 'delete_selected_suggestion_bids'
      post 'delete_selected_reviews'
      
      get 'statistics'
      post 'get_weekly_online_posts'
      post 'get_daily_online_posts'
      post 'get_monthly_online_posts'
      get 'payments'

      post 'action_on_selected_user'
      
    end
  end
  get "/remove_account_user" => "brandslip#remove_account_user", :as => :remove_account_user
  get "/touch" => "brandslip#get_in_touch", :as => :get_in_touch
  devise_for :users, :controllers => {:registrations => "registration", :sessions => "devisesession", :passwords => "passwords"}#, :confirmations => "confirmation", :registrations => "registration"}

  root :to => "brandslip#home", constraints: lambda { |r| r.env["warden"].authenticate? }, :as => :dashboard
  root :to => "landing#home", :as => :home
  root :to => "landing#home"
  match "test" => "landing#test", :as => :test
  
  match "new_account_confirm" => "landing#new_account_confirm", :as => :new_account_confirm
  
  match "unfollow" => "relationships#unfollow", :as => :unfollow
  #match "admin_login" => "admin#admin_login", :as => :admin_login
  #match "/admin/authentication" => "admin#admin_authentication", :as => :admin_authentication
  #match "admin_logout" => "admin#admin_logout", :as => :admin_logout
  #match "admin_dashboard" => "admin#admin_dashboard", :as => :admin_dashboard  

  #match "action_on_selected_user" => "admin#action_on_selected_user", :as => :action_on_selected_user,:type=>:post
  
  match "search_job" => "brandslip#search_job", :as => :search_job
  match "search_job_filter" => "brandslip#search_job_filter", :as => :search_job_filter
  match "search_job_filter_by_location" => "brandslip#search_job_filter_by_location", :as => :search_job_filter_by_location
  match "search_job_filter_by_valid_for" => "brandslip#search_job_filter_by_valid_for", :as => :search_job_filter_by_valid_for
  match "/user_job_detail/:id" => "brandslip#user_job_detail", :as => :user_job_detail
  match "/job_detail/:id" => "brandslip#job_detail", :as => :job_detail

  match "brands_profile" => "profile#brands_profile", :as => :brands_profile
  match "presenters_profile" => "profile#presenters_profile", :as => :presenters_profile
  match "search_profile_filter" => "profile#search_profile_filter", :as => :search_profile_filter
  match "search_brand_filter" => "profile#search_brand_filter", :as => :search_brand_filter
  
  post "/account_remove" => "brandslip#account_remove", :as => :account_remove
  get "/account_remove" => "brandslip#account_remove", :as => :account_remove

  match "send_message" => "brandslip#send_message", :as => :send_message
  match "presenter_profile" => "brandslip#presenter_profile", :as => :presenter_profile
  match "brand_profile" => "brandslip#brand_profile", :as => :brand_profile
  match "presenters_profile_edit" => "brandslip#presenters_profile_edit", :as => :presenters_profile_edit
  match "brands_profile_edit" => "brandslip#brands_profile_edit", :as => :brands_profile_edit
  match "delete_messages" => "brandslip#delete_messages", :as => :delete_messages
  match "presenters_profile_show" => "profile#presenters_profile_show", :as => :presenters_profile_show
  match "brands_profile_show" => "profile#brands_profile_show", :as => :brands_profile_show  
  match "edit_profile" => "brandslip#edit_profile", :as => :edit_profile1
  match "save_user" => "brandslip#save_user", :as => :save_user
  match "delete_job_proposal" => "brandslip#delete_job_proposal", :as => :delete_job_proposal
  match "show_approve_popup" => "brandslip#show_approve_popup", :as => :show_approve_popup
  match "delete_job" => "jobs#delete_job", :as => :delete_job
  match "edit_job_proposal" => "brandslip#edit_job_proposal", :as => :edit_job_proposal
  match "followings_users" => "brandslip#followings_users", :as => :followings_users
  match "followers_users" => "brandslip#followers_users", :as => :followers_users
  match "add_newsfeed" => "brandslip#add_newsfeed", :as => :add_newsfeed
  match "your_posts" => "brandslip#your_posts", :as => :your_posts
  match "delete_post" => "brandslip#delete_post", :as => :delete_post
  match "/jobs/get_cities" => "brandslip#get_cities", :as => :get_cities
  match "edit_bid" => "brandslip#edit_bid", :as => :edit_bid
  match "get_users_to_msg" => "brandslip#get_users_to_msg", :as => :get_users_to_msg
  match "/presenter_mark_done" => "brandslip#presenter_mark_done", :as => :presenter_mark_done
  match "/brand_mark_done" => "brandslip#brand_mark_done", :as => :brand_mark_done
  match "/review_rating" => "brandslip#review_rating", :as => :review_rating
  match "/suggestion_review_rating" => "brandslip#suggestion_review_rating", :as => :suggestion_review_rating
  match "/add_review_rating" => "brandslip#add_review_rating", :as => :add_review_rating
  match "/add_suggestion_review_rating" => "brandslip#add_suggestion_review_rating", :as => :add_suggestion_review_rating
  match "/review" => "brandslip#review", :as => :review
  match "/transaction_history" => "brandslip#transaction_history", :as => :transaction_history
  
  match "/faq" => "brandslip#faq", :as => :faq
 
  match "/policies" => "brandslip#policies", :as => :policies
  match "/our_team" => "brandslip#our_team", :as => :our_team
  match "/terms_conditions" => "brandslip#terms_conditions", :as => :terms_conditions
  match "/contact_us_page" => "brandslip#contact_us_page", :as => :contact_us_page

  #Accept Decline Bid
  match "/accept_bid" => "accept_decline_bid#accept_bid", :as => :accept_bid
  match "/delete_bid" => "accept_decline_bid#delete_bid", :as => :delete_bid
  match "/accept_suggestion_bid" => "accept_decline_bid#accept_suggestion_bid", :as => :accept_suggestion_bid
  match "/delete_suggestion_bid" => "accept_decline_bid#delete_suggestion_bid", :as => :delete_suggestion_bid

  # balanced API controller actions
  # match "payments/add_card" => "balanced#add_card", :as => :balanced_add_card
  # match "payments/add_bank_account" => "balanced#add_bank_account", :as => :balanced_add_bank_account

  resources :payments, only: [:new] do
    post 'add_card', :on => :collection
    post 'add_bank_account', :on => :collection
    post 'credit', :on => :collection
    post 'debit', :on => :collection
  end
  
  #Brandslip Suggestion
  match "delete_suggestion" => "brandslip_suggestions#delete_suggestion", :as => :delete_suggestion
  match "search_suggestion" => "brandslip#search_suggestion", :as => :search_suggestion
  match "/suggestion_detail/:id" => "brandslip#suggestion_detail", :as => :suggestion_detail
  match "/user_suggestion_detail/:id" => "brandslip#user_suggestion_detail", :as => :user_suggestion_detail
  match "edit_suggestion_bid" => "brandslip#edit_suggestion_bid", :as => :edit_suggestion_bid
  match "delete_suggestion_proposal" => "brandslip#delete_suggestion_proposal", :as => :delete_suggestion_proposal
  match "search_suggestion_filter" => "brandslip#search_suggestion_filter", :as => :search_suggestion_filter
  match "search_suggestion_filter_by_location" => "brandslip#search_suggestion_filter_by_location", :as => :search_suggestion_filter_by_location
  match "search_suggestion_filter_by_valid_for" => "brandslip#search_suggestion_filter_by_valid_for", :as => :search_suggestion_filter_by_valid_for  
  
  #save as interested
  match "j_save_as_interested" => "brandslip#j_save_as_interested", :as => :j_save_as_interested
  match "j_remove_from_interested" => "brandslip#j_remove_from_interested", :as => :j_remove_from_interested
  match "s_save_as_interested" => "brandslip#s_save_as_interested", :as => :s_save_as_interested
  match "s_remove_from_interested" => "brandslip#s_remove_from_interested", :as => :s_remove_from_interested
  match "interested_brandslips" => "brandslip#interested_brandslips", :as => :interested_brandslips
  match "interested_suggestions" => "brandslip#interested_suggestions", :as => :interested_suggestions
  match "delete_interest_brandslip" => "brandslip#delete_interest_brandslip", :as => :delete_interest_brandslip
  match "delete_interest_suggestion" => "brandslip#delete_interest_suggestion", :as => :delete_interest_suggestion
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
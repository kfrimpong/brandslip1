class LandingController < ApplicationController
  layout "landing_layout", :except => [:test]
  def home
    
  end

  def test

  end

  def new_account_confirm
    respond_to do |format|
      format.html { redirect_to home_path, notice: 'Thanks! You will be notified by an admin when you are approved.' }
      format.json { head :no_content }
    end    
  end
  
end

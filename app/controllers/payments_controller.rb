class PaymentsController < ApplicationController

layout 'admin_layout'

  def new
    @brands = User.where(:user_type => 1).reject{ |user| user.balanced_customer_uri.nil? }
    @presenters = User.where(:user_type => 2).reject{ |user| user.balanced_customer_uri.nil? }
  end

  def debit
    @brand = User.find(params['brand'])
    @presenter = User.find(params['presenter'])
    begin
      Balanced.configure(APP_CONFIG['balanced_secret'])
      customer = Balanced::Customer.find(@brand.balanced_customer_uri)
      amount_in_cents = (params['amount'].to_i * 100).to_s
      debit = customer.debit(:amount => amount_in_cents,
                     :appears_on_statement_as => params['appears_on_statement_as'],
                     :on_behalf_of_uri => @presenter.balanced_customer_uri
                     )
      Transaction.create(:transaction_type => 0,
                         :amount => params['amount'].to_i,
                         :uri => debit.uri,
                         :debitted_id => @brand.id,
                         :creditted_id => @presenter.id
                        )
      flash[:alert] = "Brand(#{@brand.email}) successfully charged $#{params['amount']} on behalf of #{@presenter.email}"
    rescue => e
      flash[:error] = "There was an error processing your charge: #{e.message}"
    end
    redirect_to new_payment_path
  end

  def credit
    @presenter = User.find(params['presenter'])
    begin
      Balanced.configure(APP_CONFIG['balanced_secret'])
      customer = Balanced::Customer.find(@presenter.balanced_customer_uri)
      amount_in_cents = (params['amount'].to_i * 100).to_s
      credit = customer.credit(:amount => amount_in_cents,
                     :appears_on_statement_as => params['appears_on_statement_as']
                     )
      Transaction.create(:transaction_type => 1,
                         :amount => params['amount'].to_i,
                         :uri => credit.uri
                        )
      flash[:alert] = "Presenter(#{@presenter.email}) successfully paid out $#{params['amount']}"
    rescue => e
      flash[:error] = "There was an error processing your payout: #{e.message}"
    end
    redirect_to new_payment_path
  end

  def add_card

    begin
      
      Balanced.configure(APP_CONFIG['balanced_secret'])
      marketplace = Balanced::Marketplace.mine
      customer = User.find_or_create_customer(current_user, marketplace, params)
      customer.add_card(params['balancedCreditCardURI'])
      flash[:alert] = "Card Successfully Added!"
    rescue => e
      logger.debug("Balanced Error:#{e.message}")
      flash[:error] = "There was an error adding your card"
    end
    session[:sucess_account]="successfully"
    redirect_to dashboard_path
  end

  def add_bank_account
    begin
      Balanced.configure(APP_CONFIG['balanced_secret'])
      marketplace = Balanced::Marketplace.mine
      customer = User.find_or_create_customer(current_user, marketplace, params)
      customer.add_bank_account(params['balancedBankAccountURI'])
      flash[:alert] = "Bank Account Successfully Added!"
    rescue => e
      logger.debug("Balanced Error:#{e.message}")
      flash[:error] = "There was an error adding your bank account"
    end

    redirect_to dashboard_path
  end
end
  


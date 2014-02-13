class ContactUsController < ApplicationController
  layout "admin_layout"
  # GET /contact_us
  # GET /contact_us.json
  def index
    @contact_us = ContactU.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contact_us }
    end
  end

  # GET /contact_us/1
  # GET /contact_us/1.json
  def show
    @contact_u = ContactU.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact_u }
    end
  end

  # GET /contact_us/new
  # GET /contact_us/new.json
  def new
    @contact_u = ContactU.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact_u }
    end
  end

  # GET /contact_us/1/edit
  def edit
    @contact_u = ContactU.find(params[:id])
  end

  # POST /contact_us
  # POST /contact_us.json
  def create
    @contact_u = ContactU.new(params[:contact_u])

    respond_to do |format|
      if @contact_u.save
        UserMailer.contact_us_notifier(params[:contact_u]).deliver
        format.html { redirect_to @contact_u, notice: 'Job was successfully created.' }
        format.json { render json: @contact_u, status: :created, location: @contact_u }
      else
        format.html { render action: "new" }
        format.json { render json: @contact_u.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contact_us/1
  # PUT /contact_us/1.json
  def update
    @contact_u = ContactU.find(params[:id])

    respond_to do |format|
      if @contact_u.update_attributes(params[:contact_u])
        format.html { redirect_to @contact_u, notice: 'Contact u was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact_u.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_us/1
  # DELETE /contact_us/1.json
  def destroy
    @contact_u = ContactU.find(params[:id])
    @contact_u.destroy

    respond_to do |format|
      format.html { redirect_to contact_us_url }
      format.json { head :no_content }
    end
  end

end

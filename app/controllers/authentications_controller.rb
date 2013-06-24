class AuthenticationsController < ApplicationController

  # GET /auth/:provider/callback
  def create
    auth = request.env["omniauth.auth"]  

    @authentication = Authentication.where('provider = ? AND uid = ?', auth[:provider], auth[:uid]).first
    
    @errors = false
    
    if @authentication
      @user = @authentication.user
      
    else
      @user = User.new(name: auth[:info][:name], email: auth[:info][:email])
      if @user.save
        @authentication = @user.authentications.create(provider: auth[:provider], uid: auth[:uid])
        
        if !@authentication.save
          @errors = @authentication.errors
        end
      else
        @errors = @user.errors
      end
      
    end
    
    session[:current_user_id] = @user.id
    
    if session[:mobile_app]
      session[:mobile_app] = nil
      render 'result', layout: 'mobile'
    else
      if !@errors
        redirect_to root_url
      else
        redirect_to root_url, notice: @errors
      end
    end
    
  end
  
  # GET /auth/sign_out
  def destroy
    session[:current_user_id] = nil
    redirect_to root_url
  end
  
  # GET /auth/failure
  def failure
    redirect_to root_url, notice: 'Ha ocurrido un error.'
  end
  
  # GET /auth/mobile
  def mobile
    session[:mobile_app] = true
    render layout: 'mobile'
  end

end

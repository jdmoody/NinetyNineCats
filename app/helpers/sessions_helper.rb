module SessionsHelper
  def login!(user)
    #reset_session
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token! if logged_in?
    reset_session
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logged_in?
    !!current_user
  end

  def require_user
    redirect_to new_session_url unless logged_in?
  end
end

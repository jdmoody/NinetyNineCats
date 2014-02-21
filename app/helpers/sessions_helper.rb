module SessionsHelper
  def login!(user)
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    user_token = UserToken.find_by(session_token: session[:session_token])
    user_token.destroy if logged_in?
  end

  def current_user
    return nil if session[:session_token].nil?
    user_token = UserToken.find_by(session_token: session[:session_token])
    return nil if user_token.nil?
    @current_user ||= User.find_by(id: user_token.user_id)
  end

  def logged_in?
    !!current_user
  end

  def require_user
    redirect_to new_session_url unless logged_in?
  end
end

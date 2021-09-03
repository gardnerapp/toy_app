module SessionsHelper

  # logs in a user
  def log_in(user)
    session[:user_id] = user.id
  end

  # remembers user for persistent session
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # returns current logged in user if any
  def current_user
    if (user_id = session[:user_id]) #if session[:user_id] exist set it to user_id local variable
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  # returns true if a user is logged in, retursn false if not logged in
  def logged_in?
    !current_user.nil?
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # logs out current user
  def log_out
    forget @current_user
    session.delete(:user_id)
    @current_user = nil
  end

  # redirects back to sotred location or default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

end

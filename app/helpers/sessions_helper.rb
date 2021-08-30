module SessionsHelper

  # logs in a user
  def log_in(user)
    session[:user_id] = user.id
  end

  # returns current logged in user if any
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end
  end

  # returns true if a user is logged in, retursn false if not logged in
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end

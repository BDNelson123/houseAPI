class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  protected

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(auth_token: token)
    end
  end
end

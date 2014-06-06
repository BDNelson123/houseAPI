class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  protected

  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      User.exists?(auth_token: token)
    end
  end

  def request_http_token_authentication(realm = "Application")  
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    self.__send__ :render, :json => { :error => "You are not authorized to view this page." }.to_json, :status => :unauthorized
  end
end

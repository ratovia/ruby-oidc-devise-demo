# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  def new
    puts "Enter [new] action of Users::SessionsController < Devise::SessionsController"
    super
  end

  def openid
    puts "Enter [openid] action of Users::SessionsController < Devise::SessionsController"
    redirect_to authorization_uri
  end

  def callback
    puts "Enter [callback] action of Users::SessionsController < Devise::SessionsController"
    binding.pry

    request.env["warden"].authenticate!

    redirect_to root_path
  end

  private

  def authorization_uri
    OpenIDConnect::Client.new(
      identifier: "eShi8qNUc3FLzz9euTIN8VtpQqaotCmWCsbaKoRMZ1M",
      secret: "weJeQKglKx0PHKLNSZkp8hj2JrG_3ouwaFWx4dYHh4E",
      redirect_uri: "http://localhost:3000/callback",
      authorization_endpoint: "http://localhost:3780/oauth/authorize",
      userinfo_endpoint: 'http://localhost:3780/oauth/userinfo'
    ).authorization_uri(
      response_type: 'code',
      state: set_state,
      nonce: set_nonce,
      scope: %w[openid]
    )
  end

  # CSRF 攻撃対策
  def set_state
    session[:state] = SecureRandom.hex(16)
  end

  # リプレイ攻撃対策
  def set_nonce
    session[:nonce] = SecureRandom.hex(16)
  end
end

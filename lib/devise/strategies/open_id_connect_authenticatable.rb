require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    class OpenIdConnectAuthenticatable < Authenticatable
      def authenticate!
        binding.pry # now
        puts "this is Devise::Strategies::OpenIdConnectAuthenticatable"
        oidc_client = UserAuthorization.new
        ####
        user_info = oidc_client.verify!(params["code"], session.delete(:nonce))
        user_session = mapping.to.authenticate(user_info)
        #####
        if res
          success!(user_session)
        else
          fail!(:invalid) # 認証失敗。
        end
      end

      private

      def verify!(code, nonce)
        oidc_client = OpenIDConnect::Client.new(
          identifier: "eShi8qNUc3FLzz9euTIN8VtpQqaotCmWCsbaKoRMZ1M",
          redirect_uri: "http://localhost:3000/callback",
          redirect_uri: "http://localhost:3000/callback",
          authorization_endpoint: "http://localhost:3780/oauth/authorize",
          userinfo_endpoint: 'http://localhost:3780/oauth/userinfo'
        )
        oidc_client.authorization_code = code
        access_token = oidc_client.access_token!

        id_token = decode_jwt_string(access_token.id_token)

        id_token.verify!(
          # 検証を行うフィールドをここで列挙
        )

        user_info = access_token.userinfo!

        user_info
      end

      def decode_jwt_string(jwt_string)
        OpenIDConnect::ResponseObject::IdToken.decode(jwt_string, jwk_json)
      end

      def jwk_json
        @jwks ||= JSON.parse(
            OpenIDConnect.http_client.get_content("/oauth/discovery/keys")
          ).with_indifferent_access
        JSON::JWK::Set.new @jwks[:keys]
      end
    end
  end
end

Warden::Strategies.add(:open_id_connect_authenticatable, Devise::Strategies::OpenIdConnectAuthenticatable)

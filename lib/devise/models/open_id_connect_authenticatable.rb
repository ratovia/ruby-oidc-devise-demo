require Rails.root.join('lib/devise/strategies/open_id_connect_authenticatable')

module Devise
  module Models
    module OpenIdConnectAuthenticatable
      extend ActiveSupport::Concern

      module ClassMethods
        def authenticate(attributes)
          binding.pry # goal
          res = find_by(mail: attributes[:id])
          if res.present?
            res
          else
            nil
          end
        end
      end
    end
  end
end

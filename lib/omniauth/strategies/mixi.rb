require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class Mixi < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://secure.mixi-platform.com',
        :authorize_url => 'https://mixi.jp/connect_authorize.pl',
        :token_url => 'https://secure.mixi-platform.com/2/token',
        :ssl => {:ca_path => "/etc/ssl/certs"}
      }

      option :authorize_params, {
        :scope => 'r_profile w_pagefeed',
        :display => 'pc',
        :response_type => 'code'
      }

      option :token_params, {
        :parse => :json,
        :mode => :query,
        :param_name => 'oauth_token',
        :header_format => "OAuth %s"
      }

      uid { raw_info['entry']['id']}

      info do
        {
        :name => raw_info['entry']['displayName']
        }
      end

      def callback_phase
        options[:grant_type] ||= 'client_credentials'
        super
      end

      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get("/2/people/@me/@self?oauth_token=#{access_token.token}").body)
        @raw_info
      end
    end
  end
end

__END__

require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    # Authenticate to Facebook utilizing OAuth 2.0 and retrieve
    # basic user information.
    #
    # @example Basic Usage
    #   use OmniAuth::Strategies::Mixi, 'client_id', 'client_secret'
    class Mixi < OmniAuth::Strategies::OAuth2
      # @option options [String] :scope separate the scopes by a space
      def initialize(app, client_id=nil, client_secret=nil, options={}, &block)
        client_options = {
          :authorize_url => 'https://mixi.jp/connect_authorize.pl',
          :token_url => 'https://secure.mixi-platform.com/2/token',
        }
        super(app, :mixi, client_id, client_secret, client_options, options, &block)
      end

      def auth_hash
        OmniAuth::Utils.deep_merge(
          super, {
            'uid' => user_data['entry']['id'],
            'user_info' => user_info,
            'credentials' => {'refresh_token' => @access_token.refresh_token},
            'extra' => {
              'user_hash' => user_data['entry'],
            },
          }
        )
      end

      def user_data
        @data ||= MultiJson.decode(@access_token.get(
          'http://api.mixi-platform.com/2/people/@me/@self',
          {'oauth_token' => @access_token.token}
        ))
      end

      def request_phase
        options[:scope] ||= 'r_profile'
        options[:display] ||= 'pc'
        options[:response_type] ||= 'code'
        super
      end

      def callback_phase
        options[:grant_type] ||= 'authorization_code'
        super
      end

      def user_info
        {
          'nickname' => user_data['entry']['displayName'],
          'image' => user_data['entry']['thumbnailUrl'],
          'urls' => {
            :profile => user_data['entry']['profileUrl'],
          },
        }
      end
    end
  end
end

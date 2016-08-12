require 'cuba'
require 'rack/cache'

module ShariffBackend
  # Cuba/Rack application which routes the requests to the providers
  class App < ::Cuba
    PROVIDERS = [Facebook, GooglePlus, LinkedIn]

    # TODO: make cache configurable
    use Rack::Cache,
        verbose: true,
        default_ttl: 60 * 60 # 1 hour

    def valid_referrer?
      allowed_referrer = self.class.settings[:allowed_referrer]
      return true if allowed_referrer.nil?
      if allowed_referrer.is_a?(String)
        req.referrer == allowed_referrer
      elsif allowed_referrer.is_a?(Regexp)
        allowed_referrer.match(req.referrer)
      else
        raise ArgumentError, "Can't use #{allowed_referrer.class.name} for referrer checks"
      end
    end

    def verify_referrer
      return if valid_referrer?
      res.status = 403
      res.write('Not authorized')
      halt(res.finish)
    end

    def provider_name(provider)
      name = provider.name.split('::').last || provider.name
      name.downcase
    end

    def all_provider_data(url)
      PROVIDERS.map do |provider|
        [provider_name(provider), provider.count(url)]
      end
    end

    define do
      on get do
        # Requests to the root return counts from all providers
        on root, param('url') do |url|
          verify_referrer
          data = Hash[all_provider_data(url)]
          res.write(JSON.dump(data))
        end

        # It's also possible to query providers individually
        PROVIDERS.each do |provider|
          on provider_name(provider), param('url') do |url|
            verify_referrer
            res.write(provider.count(url))
          end
        end
      end
    end
  end
end

$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'rack/test'
require 'webmock'

require 'shariff_backend'

# Set up Cutest to test this app
# rubocop:disable Style/ClassAndModuleChildren
class Cutest::Scope
  include Rack::Test::Methods

  def app
    ShariffBackend::App
  end
end

setup do
  WebMock.disable_net_connect!
end

scope 'Disable' do
  URL_TO_TEST = 'https://marcusilgner.com'

  scope 'root' do
    setup do
      ShariffBackend::App.settings[:disable_and_return] = 42
    end

    test 'always returns 42' do
      get "/?url=#{URL_TO_TEST}"
      assert(last_response.body.length > 10)
      parsed = JSON.parse(last_response.body)
      assert(parsed.key?('googleplus'))
      assert_equal(parsed['googleplus'], 42)
      assert(parsed.key?('linkedin'))
      assert_equal(parsed['linkedin'], 42)
    end
  end
end

$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend/facebook'

include WebMock::API

scope do
  def url_to_test
    'https://marcusilgner.com'
  end

  setup do
    WebMock.enable!
    WebMock.disable_net_connect!
    stub_request(:get, %r{\Ahttps://api\.facebook\.com/method/fql\.query.+#{url_to_test}})
      .to_return(body: '[{"share_count": 123}]')
  end

  test 'Facebook' do
    count = ShariffBackend::Facebook.count(url_to_test)
    assert_equal(123, count)
  end
end

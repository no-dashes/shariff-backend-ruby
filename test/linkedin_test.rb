$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend/linkedin'

include WebMock::API
WebMock.enable!

scope do
  def url_to_test
    'https://marcusilgner.com'
  end

  setup do
    WebMock.enable!
    WebMock.disable_net_connect!
    stub_request(:get, %r{https://www.linkedin.com/countserv/count/share?.*url=#{url_to_test}})
      .to_return(body: '{"count":8,"fCnt":"8","fCntPlusOne":"9","url":"https:\/\/marcusilgner.com"}')
  end

  test 'LinkedIn' do
    count = ShariffBackend::LinkedIn.count(url_to_test)
    assert_equal(8, count)
  end
end

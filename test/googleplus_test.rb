$LOAD_PATH.push File.expand_path('../../lib', __FILE__)

require 'cutest'
require 'webmock'
require 'rr/without_autohook'

require 'shariff_backend/googleplus'

include WebMock::API

scope 'Google+' do
  def url_to_test
    'http://marcusilgner.com'
  end

  GOOGLE_FAKE_RESPONSE = <<EOS
    <!DOCTYPE html>
    <html lang="de" dir="ltr">
      <head><base href="https://plusone.google.com/wm/1/"></head>
      <body class="kv8eNc ">
        <div id="root">
          <div id="aggregateCount" class="Oy">18</div>
        </div>
      </body>
    </html>
EOS

  setup do
    WebMock.enable!
    WebMock.disable_net_connect!
    stub_request(:get, %r{\Ahttps://plusone\.google\.com/.+#{url_to_test}\Z})
      .to_return(body: GOOGLE_FAKE_RESPONSE)
  end

  test 'with protocol' do
    count = ShariffBackend::GooglePlus.count(url_to_test)
    assert_equal('18', count)
  end

  test 'without protocol' do
    count = ShariffBackend::GooglePlus.count('marcusilgner.com')
    assert_equal('18', count)
  end
end

require 'net/http'
require 'json'

class CallApi
  def call(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.instance_of? URI::HTTPS
    request = Net::HTTP::Get.new(uri.request_uri)
    thing = http.request(request)
    JSON.parse(thing.body)
  end
end
module RequestsHelper
  def jsonapi_request(method, path, args = {})
    args[:headers] ||= {}
    args[:headers]["Content-Type"] = "application/vnd.api+json" if !args[:public] || (args[:public] && method == :patch)

    public_send(method, path, params: args[:params], as: args[:as], headers: args[:headers])
  end

end

RSpec.configure do |config|
  config.include RequestsHelper, type: :request
end

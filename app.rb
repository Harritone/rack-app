require_relative 'time_formatter'
class App
  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new
    body, status = perform_format(req)
    perform_response(res, body, status)
  end

  private

  def handle_method_and_path(req)
    return ["Not found\n"] unless req.get? && req.path == '/time'
    return ["Should match the pattern \"format=\"\n"] unless req.params['format']
    # []
  end

  def perform_format(req)
    errors = handle_method_and_path(req)
    if errors&.any?
      [errors, 404]
    else
      params = req.params['format']
      formatter = TimeFormatter.new(params)
      body = formatter.perform
      status = formatter.success? ? 200 : 400
      [body, status]
    end
  end

  def perform_response(res, body, status)
    res.body = body
    res.status = status
    res.headers['Content-Type'] = 'text/plain'
    res.finish
  end
end

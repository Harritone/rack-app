require_relative 'time_formatter'
class App
  class PathError < StandardError
    def initialize(msg)
      super(msg)
    end

    def status
      404
    end
  end

  def call(env)
    @req = Rack::Request.new(env)
    init_response
    perform_format
    @res.finish
  end

  private

  def init_response
    @res = Rack::Response.new
    @res.headers['Content-Type'] = 'text/plain'
  end

  def handle_method_and_path
    raise PathError.new("Not found\n") unless @req.get? && @req.path == '/time'
    raise PathError.new('Should match the pattern "format="') unless @req.params['format']
  end

  def perform_format
    handle_method_and_path
    params = @req.params['format']
    formatter = TimeFormatter.new(params)
    @res.body = formatter.perform
  rescue TimeFormatter::UnknownFormatError => e
    @res.body = [e.message]
    @res.status = 400
  rescue PathError => e
    @res.status = e.status
    @res.body = [e.message]
  end
end

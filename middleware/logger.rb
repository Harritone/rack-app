require 'logger'

class AppLogger
  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    # p self.class
    request = Rack::Request.new(env)
    # @logger.info(env["HTTP_"])
    response = Rack::Response.new
    # @logger.info(request.params['format'].split(','))
    @logger.info(response.status)
    @app.call(env)
  end
end

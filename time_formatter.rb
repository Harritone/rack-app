class TimeFormatter
  TIME_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  class PathError < StandardError
    def initialize(msg)
      super(msg)
    end

    def status
      404
    end
  end

  class UnknownFormatError < StandardError
    def initialize(msg)
      super(msg)
    end
    def status
      400
    end
  end

  def initialize
    @invalid_formats = []
    @valid_formats = []
  end

  def call(env)
    req= Rack::Request.new(env)
    res= Rack::Response.new
    res.headers['Content-Type'] = 'text/plain'
    perform_format(req, res)
    res.finish
  end

  private
  
  def perform_format(req, res )
    handle_method_and_path(req)
    res.body = handle_time_format(req, res)
  rescue PathError, UnknownFormatError => e
    res.status = e.status
    res.body = [e.message]
  end

  def handle_time_format(req, res)
    raise PathError.new('Should match the pattern "format="') unless req.params['format']
    formats = req.params['format'].split(',')
    formats.each do |format|
      if TIME_FORMATS[format]
        @valid_formats << TIME_FORMATS[format]
      else
        @invalid_formats << format
      end
    end
    raise UnknownFormatError.new("Unknown time format #{@invalid_formats}\n") if @invalid_formats.size.positive?
    ["#{Time.now.strftime(@valid_formats.join('-'))}\n"]
  end

  def handle_method_and_path(req)
    raise PathError.new("Not found\n") unless req.post? || req.path == '/time'
  end
end

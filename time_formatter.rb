class TimeFormatter
  TIME_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  class UnknownFormatError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  def initialize(params)
    @params = params.split(',')
    @valid_formats = []
    @invalid_formats = []
  end

  def perform
    @params.each do |param|
      if TIME_FORMATS[param]
        @valid_formats << TIME_FORMATS[param]
      else
        @invalid_formats << param
      end
    end

    raise UnknownFormatError.new("Unknown time format #{@invalid_formats}\n") unless success?
    ["#{Time.now.strftime(@valid_formats.join('-'))}\n"]
  end

  private

  def success?
    @invalid_formats.length.zero?
  end
end

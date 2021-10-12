require_relative 'app'
require_relative 'middleware/logger'
require_relative 'middleware/runtime'
require_relative 'time_formater'

# use TimeFormatter
# use AppLogger
run TimeFormatter.new

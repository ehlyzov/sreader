require_relative "sreader/version"

module Sreader
  autoload :DSL, 'sreader/dsl'

  module Readers; end
  module Factories; end
end

require_relative 'sreader/block_translator'

require_relative 'sreader/readers/array_reader'
require_relative 'sreader/readers/hash_reader'

require_relative 'sreader/factories/struct_factory'

require_relative 'sreader/fn_resolver'


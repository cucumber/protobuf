# Adapted from: https://github.com/rails/rails/blob/v6.0.3.2/activesupport/lib/active_support/inflector/methods.rb

require 'protobuf/refinements/string/camelize'

module Protobuf
  module Refinements
    module String
      module Classify
        refine ::String do
          using Protobuf::Refinements::String::Camelize

          def classify
            split('/').map { |c| c.camelize(:upper) }.join('::')
          end
        end
      end
    end
  end
end

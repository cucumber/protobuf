# Adapted from: https://github.com/rubyworks/facets/blob/master/lib/core/facets/string/snakecase.rb

module Protobuf
  module Refinements
    module String
      module Underscore
        refine ::String do
          def underscore(*separators)
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr('-', '_').
            gsub(/\s/, '_').
            gsub(/__+/, '_').
            downcase
          end
        end
      end
    end
  end
end

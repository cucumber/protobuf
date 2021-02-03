# Adapted from: https://github.com/rubyworks/facets/blob/master/lib/core/facets/string/camelcase.rb

module Protobuf
  module Refinements
    module String
      module Camelize
        refine ::String do
          def camelize(*separators)
            case separators.first
            when Symbol, TrueClass, FalseClass, NilClass
              first_letter = separators.shift
            end

            separators = ['_', '\s'] if separators.empty?

            str = dup

            separators.each do |s|
              str = str.gsub(/(?:#{s}+)([a-z])/) { $1.upcase } # rubocop:disable Style/PerlBackrefs
            end

            case first_letter
            when :upper, true
              str = str.gsub(/(\A|\s)([a-z])/) { $1 + $2.upcase } # rubocop:disable Style/PerlBackrefs
            when :lower, false
              str = str.gsub(/(\A|\s)([A-Z])/) { $1 + $2.downcase } # rubocop:disable Style/PerlBackrefs
            end

            str
          end
        end
      end
    end
  end
end

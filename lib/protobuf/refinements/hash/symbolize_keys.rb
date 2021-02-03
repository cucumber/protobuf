# Adapted from: https://github.com/rails/rails/blob/v6.0.3.2/activesupport/lib/active_support/core_ext/hash/keys.rb

module Protobuf
  module Refinements
    module Hash
      module SymbolizeKeys
        refine ::Hash do
          def symbolize_keys
            transform_keys do |key|
              begin
                key.to_sym
              rescue
                key
              end
            end
          end
        end
      end
    end
  end
end

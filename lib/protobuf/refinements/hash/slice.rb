# Adapted from: https://github.com/rubyworks/facets/blob/master/lib/core/facets/hash/slice.rb

module Protobuf
  module Refinements
    module Hash
      module Slice
        refine ::Hash do
          def slice(*keep_keys)
            if block_given?
              each do |k, v|
                keep_keys << k if yield(k, v)
              end
            end

            keep_keys.each_with_object({}) do |key, hash|
              hash[key] = fetch(key) if key?(key)
            end
          end

          def slice!(*keep_keys)
            if block_given?
              each do |k, v|
                keep_keys << k if yield(k, v)
              end
            end

            rejected = keys - keep_keys
            removed = {}
            rejected.each { |k| removed[k] = delete(k) }
            removed
          end
        end
      end
    end
  end
end

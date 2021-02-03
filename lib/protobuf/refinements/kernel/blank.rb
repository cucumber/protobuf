# Adapted from: https://github.com/rubyworks/facets/blob/master/lib/core/facets/kernel/blank.rb

module Protobuf
  module Refinements
    module Kernel
      module Blank
        refine ::Kernel do
          def blank?
            return empty? if respond_to?(:empty?)
            !self
          end

          def present?
            !blank?
          end

          def presence
            self if present?
          end
        end

        refine ::NilClass do
          def blank?
            true
          end
        end

        refine ::FalseClass do
          def blank?
            true
          end
        end

        refine ::TrueClass do
          def blank?
            false
          end
        end

        refine ::Array do
          alias_method :blank?, :empty?
        end

        refine ::Hash do
          alias_method :blank?, :empty?
        end

        refine ::String do
          def blank?
            /\S/ !~ self
          end
        end

        refine ::Numeric do
          def blank?
            false
          end
        end
      end
    end
  end
end

# Adapted from: https://github.com/rails/rails/blob/v6.0.3.2/activesupport/lib/active_support/core_ext/object/blank.rb

module Protobuf
  module Refinements
    module Object
      module Blank
        refine ::Object do
          def blank?
            respond_to?(:empty?) ? !!empty? : !self
          end

          def present?
            !blank?
          end
        end
      end
    end
  end
end

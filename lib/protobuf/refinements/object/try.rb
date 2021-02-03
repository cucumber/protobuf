# Adapted from: https://github.com/rails/rails/blob/v6.0.3.2/activesupport/lib/active_support/core_ext/object/try.rb

module Protobuf
  module Refinements
    module Object
      module Try
        module Tryable #:nodoc:
          def try(method_name = nil, *args, &b)
            if method_name.nil? && block_given?
              if b.arity == 0
                instance_eval(&b)
              else
                yield self
              end
            elsif respond_to?(method_name)
              public_send(method_name, *args, &b)
            end
          end
          ruby2_keywords(:try) if respond_to?(:ruby2_keywords, true)

          def try!(method_name = nil, *args, &b)
            if method_name.nil? && block_given?
              if b.arity == 0
                instance_eval(&b)
              else
                yield self
              end
            else
              public_send(method_name, *args, &b)
            end
          end
          ruby2_keywords(:try!) if respond_to?(:ruby2_keywords, true)
        end

        refine ::Object do
          include Tryable
        end

        if Object.const_defined?('::Delegator')
          refine ::Delegator do
            include Tryable
          end
        end

        refine ::NilClass do
          def try(_method_name = nil, *_args)
            nil
          end

          def try!(_method_name = nil, *_args)
            nil
          end
        end
      end
    end
  end
end

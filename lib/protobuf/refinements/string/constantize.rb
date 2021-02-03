# Adapted from: https://github.com/rails/rails/blob/v6.0.3.2/activesupport/lib/active_support/inflector/methods.rb

module Protobuf
  module Refinements
    module String
      module Constantize
        refine ::String do
          def constantize
            names = split("::")

            # Trigger a built-in NameError exception including the ill-formed constant in the message.
            Object.const_get(self) if names.empty?

            # Remove the first blank element in case of '::ClassName' notation.
            names.shift if names.size > 1 && names.first.empty?

            names.inject(Object) do |constant, name|
              if constant == Object
                constant.const_get(name)
              else
                candidate = constant.const_get(name)
                next candidate if constant.const_defined?(name, false)
                next candidate unless Object.const_defined?(name)

                # Go down the ancestors to check if it is owned directly. The check
                # stops when we reach Object or the end of ancestors tree.
                constant = constant.ancestors.inject(constant) do |const, ancestor| # rubocop:disable Style/EachWithObject
                  break const    if ancestor == Object
                  break ancestor if ancestor.const_defined?(name, false)
                  const
                end

                # owner is in Object, so raise
                constant.const_get(name, false)
              end
            end
          end

          def safe_constantize
            constantize
          rescue NameError => e
            raise if e.name && !(to_s.split("::").include?(e.name.to_s) ||
              e.name.to_s == to_s)
          rescue ArgumentError => e
            raise unless /not missing constant #{const_regexp(self)}!$/.match?(e.message)
          rescue LoadError => e
            raise unless /Unable to autoload constant #{const_regexp(self)}/.match?(e.message)
          end
        end
      end
    end
  end
end

module Isy
  module Component
    module Developer
      module Inspection

        class Object < Base

          attr_reader :obj, :label, :components
          attr_writer :packed

          def initialize(context, obj, label = nil, packed = true)
            @obj, @packed, @label = obj, packed, label
            super(context)            
          end

          def initial_state
            @packed ? pack : unpack
          end

          def packed?
            @packed
          end

          def switch_packed
            @packed = !@packed
            @packed ? pack : unpack
          end

          protected

          def unpack
            @components = [
              inspector(
                obj.instance_variables.inject({}) {|hash, name| hash[name] = obj.instance_variable_get(name); hash },
                'Instance variables')
            ]
          end

          def pack
            @components = []
          end

          class Widget < Widget::Component
            delegate :obj, :label, :packed?, :variables, :components

            def content
              packed
              ul { unpacked } unless packed?
            end

            def packed
              link_to("#{label ? label + ' ' : nil}#{name}") { switch_packed }
            end

            def name
              "##{obj.class}"
            end

            def unpacked
              li "size #{obj.size}" if obj.respond_to?(:size)
              components.each do |c|
                li { render c }
              end
            end

          end

        end
      end
    end
  end
end

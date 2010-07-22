module Hammer
  module Component
    module Developer

      # Inspection components
      module Inspection


        class Object < Base

          attr_reader :obj, :label, :components
          attr_writer :packed

          # @param [Object] obj to inspect
          # @param [String] label optional description
          # @param [Boolean] packed inspector is initially packed?
          def initialize(context, obj, label = nil, packed = true)
            @obj, @packed, @label = obj, packed, label
            super(context)            
          end

          def initial_state
            @packed ? pack : unpack
          end

          # @return [Boolean] is inspector packed?
          def packed?
            @packed
          end

          # switches packed state and calls {#pack} or {#unpack} to change the state
          def switch_packed
            @packed = !@packed
            @packed ? pack : unpack
          end

          protected

          # unpacks inspector, creates subinspectors for instance variables, constants etc.
          def unpack
            @components = [
              inspector(
                obj.instance_variables.inject({}) {|hash, name| hash[name] = obj.instance_variable_get(name); hash },
                'Instance variables')
            ]
          end

          # packs inspector, drops subinspectors
          def pack
            @components = []
          end

          class Widget < Widget::Component
            def content
              packed
              ul { unpacked } unless c.packed?
            end

            # renders packed form
            def packed
              cb.a("#{c.label ? c.label + ' ' : nil}#{name}").event(:click).action! { switch_packed }
            end

            # renders name of the inspector
            def name
              "##{c.obj.class}"
            end

            # renders unpacked form
            def unpacked
              li "size #{c.obj.size}" if c.obj.respond_to?(:size)
              c.components.each do |c|
                li { render c }
              end
            end

          end

        end
      end
    end
  end
end

# encoding: UTF-8

module Isy
  module Widget

    # Abstract class of widgets used to render components
    class Component < Base

      needs :component
      attr_reader :component
      alias_method(:c, :component)

      wrap_in :div

      # automatically passes :component assign to child widgets
      def widget(target, assigns = {}, options = {}, &block)
        assigns.merge!(:component => @component) {|_,old,_| old } if target.is_a? Class
        super target, assigns, options, &block
      end

      def a(*args, &block)
        super *args.push(args.extract_options!.merge(:href => '#')), &block
      end

      # calls missing methods on component
      def method_missing(method, *args, &block)
        if component.respond_to?(method)
          component.__send__ method, *args, &block
        else
          super
        end
      end

      def respond_to?(symbol, include_private = false)
        component.respond_to?(symbol) || super
      end

      protected

      # TODO check performance

      # jquery events TODO tested only uncommented
      EVENTS = ['click', 'dblclick', 'change'].map(&:to_sym)
      #      EVENTS = [ 'blur', 'focus', 'focusin', 'focusout', 'load', 'resize', 'scroll', 'unload', 'click', 'dblclick',
      #        'mousedown', 'mouseup', 'mousemove', 'mouseover', 'mouseout', 'mouseenter', 'mouseleave', 'change', 'select',
      #        'submit', 'keydown', 'keypress', 'keyup', 'error'].map(&:to_sym)

      # catches events and stores them into data attributes
      def __element__(raw, tag_name, *args, &block)
        super raw, tag_name, *(args.push(jsonify_callbacks!(args.extract_options!))), &block
      end

      # catches events and stores them into data attributes
      def __empty_element__(tag_name, attributes={})
        super tag_name, jsonify_callbacks!(attributes)
      end

      # action callback
      # @example triggers action when a element is clicked
      #   div :click => do_action { @counter += 1 }
      def do_action(&block)
        { :action => register_action(&block) }
      end

      # form callback
      # @example triggers form actualization when a element is clicked
      #   div :click => actualize_form(form_id)
      # @param [Object, Fixnum] form_id a Fixnum or Object where its #object_id is called to get form_id
      def actualize_form(form_id = component)
        form_id = form_id.object_id unless form_id.is_a? Fixnum
        { :form => form_id }
      end

      # alters callbacks in +options+ into data-* attributes
      def jsonify_callbacks!(options)
        (options.keys & EVENTS).each do |event|
          options[:"data-callback-#{event}"] = JSON[ [*options.delete(event)].inject({}) do |hash, cb|
              hash.merge! cb.is_a?(Hash) ? cb : {cb[0] => cb[1]}
            end ]
        end
        options
      end

      private

      # registers action to {#component} for later evaluation
      # @yield action block to register
      # @return [String] uuid of the action
      def register_action(&block)
        component.context.register_action(component, &block)
      end

    end
  end
end
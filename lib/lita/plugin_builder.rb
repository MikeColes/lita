# frozen_string_literal: true

require_relative "adapter"
require_relative "handler"

module Lita
  # Constructs a Lita plugin from a block.
  # @since 4.0.0
  # @api private
  class PluginBuilder
    # @param namespace [String, Symbol] The Redis namespace to use for the plugin.
    # @yield The class body of the plugin.
    def initialize(namespace, &block)
      @namespace = namespace.to_s
      @block = block
    end

    # Constructs an {Adapter} from the provided block.
    # @return [Adapter]
    def build_adapter
      adapter = create_plugin(Adapter)
      adapter.class_exec(&@block)
      adapter
    end

    # Constructs a {Handler} from the provided block.
    # @return [Handler]
    def build_handler
      handler = create_plugin(Handler)
      handler.class_exec(&@block)
      handler
    end

    private

    # Creates a class of the relevant plugin type and sets its namespace.
    def create_plugin(plugin_type)
      plugin = Class.new(plugin_type)
      plugin.namespace(@namespace)
      plugin
    end
  end
end

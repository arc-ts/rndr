# -*- encoding: utf-8 -*-
# frozen_string_literal: true
require 'erb'

module Rndr
  # Handles the rendering of a template file.
  class Template
    # Constructs a new instance of Template
    # @param path [String] The path to the template file.
    # @param vars [Hash] A hash of the variables to be passed to the template's binding.
    def initialize(path:, vars: {})
      @path = path
      @vars = vars
    end

    # @return [Boolean]  True if template is renderable.
    def render?
      render_helper
    end

    # @param render_path [String] Path to desired rendered template location.
    # @return [Boolean] True if template is renderable.
    def render(render_path)
      render_helper(render_path)
    end

    private

    # @param render_path [String] Path to desired rendered template location.
    # @return [Boolean] True if template is renderable, and rendered file written.
    def render_helper(render_path = nil)
      b = binding
      @vars.each { |k, v| b.local_variable_set(k, v) }
      rendered = ERB.new(File.read(@path)).result(b)
      unless render_path.nil?
        File.open(render_path, 'w') { |f| f.write(rendered) }
      end
      true
    rescue
      false
    end
  end
end

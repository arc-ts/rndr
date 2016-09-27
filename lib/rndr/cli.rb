# -*- encoding: utf-8 -*-
# frozen_string_literal: true
require 'thor'

module Rndr
  # Parent CLI controls for Rndr.
  # @author Bob Killen <rkillen@umich.edu>
  class CLI < Thor
    desc 'check', 'Verifies discovered erb templates.'
    method_option :extension,
                  aliases: :e, type: :string, default: 'erb',
                  desc: 'Extension of templates.'
    method_option :merge,
                  aliases: :m, type: :boolean, default: true,
                  desc: 'Recursively merge variables instead of replacing.'
    method_option :template,
                  aliases: :t, type: :string, default: Dir.pwd,
                  desc: 'Path to erb template or directory.'
    method_option :vars,
                  aliases: :V, type: :string, default: File.join(Dir.pwd, 'vars'),
                  desc: 'Path to var file or directory.'
    def check
      results =
        Rndr.matches(path: options[:template], ext: options[:extension], ignore_file: '.rndrignore')
      template_vars = Rndr.read_vars(path: options[:vars], merge: options[:merge])
      results.each do |path|
        template = Template.new(path: path, vars: template_vars)
        print_check_result(path: path, result: template.render?)
      end
    end

    desc 'list', 'List discovered templates.'
    method_option :extension,
                  aliases: :e, type: :string, default: 'erb',
                  desc: 'Extension of templates.'
    method_option :template,
                  aliases: :t, type: :string, default: Dir.pwd,
                  desc: 'Path to erb template or directory.'
    def list
      results =
        Rndr.matches(path: options[:template], ext: options[:extension], ignore_file: '.rndrignore')
      if results.empty?
        puts 'No matching results.'
      else
        puts results
      end
    end

    desc 'render', 'Renders discovered templates.'
    method_option :extension,
                  aliases: :e, type: :string, default: 'erb',
                  desc: 'Extension of templates.'
    method_option :merge,
                  aliases: :m, type: :boolean, default: true,
                  desc: 'Recursively merge variables instead of replacing.'
    method_option :template,
                  aliases: :t, type: :string, default: Dir.pwd,
                  desc: 'Path to erb template or directory.'
    method_option :vars,
                  aliases: :V, type: :string, default: File.join(Dir.pwd, 'vars'),
                  desc: 'Path to var file or directory.'
    def render
      results =
        Rndr.matches(path: options[:template], ext: options[:extension], ignore_file: '.rndrignore')
      template_vars = Rndr.read_vars(path: options[:vars], merge: options[:merge])
      results.each do |path|
        template = Template.new(path: path, vars: template_vars)
        render_path = path.gsub(/.#{options[:extension]}$/, '')
        template.render(render_path) if template.render?
        print_check_result(path: render_path, result: template.render?)
      end
    end

    desc 'vars', 'Lists Combined Variables.'
    method_option :format,
                  aliases: :f, type: :string, default: 'yaml',
                  desc: 'Output Format [yaml|json]'
    method_option :merge,
                  aliases: :m, type: :boolean, default: true,
                  desc: 'Recursively merge variables instead of replacing.'
    method_option :vars,
                  aliases: :V, type: :string, default: File.join(Dir.pwd, 'vars'),
                  desc: 'Path to var file or directory.'
    def vars
      result = Rndr.read_vars(path: options[:vars], merge: options[:merge])
      case options[:format].downcase
      when 'json'
        puts result.to_json
      when 'yaml'
        puts result.to_yaml
      else
        puts 'Invalid Format.'
      end
    end

    desc 'version', 'Prints rndr Version Information.'
    map %w(-v --version) => :version
    def version
      puts "Rndr Version: #{Rndr::VERSION}"
    end

    private

    # print_check_result puts the results of an attempted Template.render? action.
    # @param path [String] Path to template or rendered template.
    # @param result [Boolean] True is successfully rendered template.
    def print_check_result(path:, result:)
      case result
      when true
        puts "#{path} [OK]"
      when false
        puts "#{path} [FAIL]"
      end
    end
  end
end

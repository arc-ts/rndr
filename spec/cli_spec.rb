# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require 'fileutils'
require 'rndr'
require_relative 'spec_helper'

module Rndr # rubocop:disable Metrics/ModuleLength
  RSpec.describe CLI do
    before(:each) do
      Dir.chdir(File.join(Dir.pwd, 'test'))
    end

    after(:each) do
      Dir.chdir('../')
    end

    let(:cli) { described_class.new }

    context 'check' do
      it 'Performs check with default options.' do
        cli.options = {
          extension: 'erb', ignore: '.rndrignore',
          merge: true, template: 'templates', vars: 'vars'
        }
        expect { cli.check }.to output(/rendertest.txt.erb \[OK\]$/).to_stdout
        expect { cli.check }.to_not output(/ignoretest.txt.erb [OK]$/).to_stdout
      end
      it 'Performs check with alternate extension.' do
        cli.options = {
          extension: 'tmplt', ignore: '.rndrignore',
          merge: true, template: 'templates', vars: 'vars'
        }
        expect { cli.check }.to output(/exttest.txt.tmplt \[OK\]$/).to_stdout
        expect { cli.check }.to_not output(/.erb/).to_stdout
      end
    end

    context 'list' do
      it 'Lists templates with default options.' do
        cli.options = { extension: 'erb', ignore: '.rndrignore', template: 'templates' }
        expect { cli.list }.to output(/rendertest.txt.erb$/).to_stdout
        expect { cli.list }.to_not output(/ignoretest.txt.erb/).to_stdout
      end
      it 'Lists templates with alternate extension.' do
        cli.options = { extension: 'tmplt', ignore: '.rndrignore', template: 'templates' }
        expect { cli.list }.to output(/exttest.txt.tmplt$/).to_stdout
        expect { cli.list }.to_not output(/.erb/).to_stdout
      end
    end

    context 'render' do
      let(:rendered_file) { File.absolute_path('../test/templates/rendertest.txt') }
      let(:rendered_ext) { File.absolute_path('../test/templates/exttest.txt') }
      let(:rendered_merged) do
        File.join(File.dirname(__FILE__), 'spec_resources/rendered_merged.txt')
      end
      let(:rendered_replaced) do
        File.join(File.dirname(__FILE__), 'spec_resources/rendered_replaced.txt')
      end
      after(:each) do
        File.delete(rendered_file) if File.exist?(rendered_file)
        File.delete(rendered_ext) if File.exist?(rendered_ext)
      end
      it 'Renders with default options.' do
        cli.options = {
          extension: 'erb', ignore: '.rndrignore',
          merge: true, template: 'templates', vars: 'vars'
        }
        expect { cli.render }.to output(/rendertest.txt \[OK\]$/).to_stdout
        expect { cli.render }.to_not output(/ignoretest.txt/).to_stdout
        expect(FileUtils.compare_file(rendered_merged, rendered_file)).to be_truthy
      end
      it 'Renders with replace merge strategy.' do
        cli.options = {
          extension: 'erb', ignore: '.rndrignore',
          merge: false, template: 'templates', vars: 'vars'
        }
        expect { cli.render }.to output(/rendertest.txt \[OK\]$/).to_stdout
        expect { cli.render }.to_not output(/ignoretest.txt/).to_stdout
        expect(FileUtils.compare_file(rendered_replaced, rendered_file)).to be_truthy
      end
      it 'Renders with alternate extension.' do
        cli.options = {
          extension: 'tmplt', ignore: '.rndrignore',
          merge: true, template: 'templates', vars: 'vars'
        }
        expect { cli.render }.to output(/exttest.txt \[OK\]$/).to_stdout
        expect { cli.render }.to_not output(/rendertest.txt/).to_stdout
        expect(FileUtils.compare_file(rendered_merged, rendered_ext)).to be_truthy
      end
    end

    context 'vars' do
      let(:vars_merged) do
        File.read(File.join(File.dirname(__FILE__), 'spec_resources/vars_merged.txt'))
      end
      let(:vars_replaced) do
        File.read(File.join(File.dirname(__FILE__), 'spec_resources/vars_replaced.txt'))
      end
      it 'Variables are recursively merged.' do
        cli.options = { format: 'yaml', merge: true, vars: 'vars' }
        expect { cli.vars }.to output(vars_merged).to_stdout
      end
      it 'Variables are replaced.' do
        cli.options = { format: 'yaml', merge: false, vars: 'vars' }
        expect { cli.vars }.to output(vars_replaced).to_stdout
      end
    end

    context 'version' do
      it 'Prints version string successfully.' do
        expect { cli.version }.to output(/Rndr Version: #{VERSION}$/).to_stdout
      end
    end
  end
end

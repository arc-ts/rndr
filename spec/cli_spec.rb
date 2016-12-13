# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# rubocop:disable Metris/ModuleLength
# rubocop:disable Metris/BlockLength
require 'fileutils'
require 'rndr'
require_relative 'spec_helper'

module Rndr
  RSpec.describe CLI do
    before(:all) { Dir.chdir(File.join(Dir.pwd, 'spec/resources')) }
    let(:cli) { CLI.new }
    describe '#check' do
      context 'When the default options are supplied' do
        before do
          cli.options = {
            extension: 'erb', ignore: 'rndrignore', merge: true,
            merge_opts: {}, template: 'templates', vars: 'vars'
          }
        end
        it 'should list the correctly matched results' do
          expect { cli.check }.to output(/rendertest.txt.erb \[OK\]$/).to_stdout
          expect { cli.check }.to_not output(/ignoretest.txt.erb [OK]$/).to_stdout
        end
      end

      context 'When a merge option is supplied' do
        before do
          cli.options = {
            extension: 'erb', ignore: 'rndrignore', merge: true,
            merge_opts: { 'overwrite_arrays' => 'true' }, template: 'templates', vars: 'vars'
          }
        end
        it 'should list the correctly matched results' do
          expect { cli.check }.to output(/rendertest.txt.erb \[OK\]$/).to_stdout
          expect { cli.check }.to_not output(/ignoretest.txt.erb [OK]$/).to_stdout
        end
      end

      context 'When an alternate exntesion is provided' do
        before do
          cli.options = {
            extension: 'tmplt', ignore: 'rndrignore', merge: true,
            merge_opts: {}, template: 'templates', vars: 'vars'
          }
        end
        it 'should list the correctly matched results' do
          expect { cli.check }.to output(/exttest.txt.tmplt \[OK\]$/).to_stdout
          expect { cli.check }.to_not output(/.erb/).to_stdout
        end
      end
    end

    describe '#list' do
      context 'When the default options are supplied' do
        before { cli.options = { extension: 'erb', ignore: 'rndrignore', template: 'templates' } }
        it 'should list the correctly matched results' do
          expect { cli.list }.to output(/rendertest.txt.erb$/).to_stdout
          expect { cli.list }.to_not output(/ignoretest.txt.erb/).to_stdout
        end
      end
      context 'When an alternate extension is provided' do
        before do
          cli.options = { extension: 'tmplt', ignore: 'rndrignore', template: 'templates' }
        end
        it 'should list the correctly matched results' do
          expect { cli.list }.to output(/exttest.txt.tmplt$/).to_stdout
          expect { cli.list }.to_not output(/.erb/).to_stdout
        end
      end
    end

    describe '#render' do
      let(:rendered_file) { File.absolute_path('templates/rendertest.txt') }
      let(:rendered_ext) { File.absolute_path('templates/exttest.txt') }
      let(:spec_merged) { File.absolute_path('spec_merged.txt') }
      let(:spec_opts) { File.absolute_path('spec_opts.txt') }
      let(:spec_replaced) { File.absolute_path('spec_replaced.txt') }
      after(:each) do
        File.delete(rendered_file) if File.exist?(rendered_file)
        File.delete(rendered_ext) if File.exist?(rendered_ext)
      end

      context 'When the defaults are supplied' do
        before do
          cli.options = {
            extension: 'erb', ignore: 'rndrignore', merge: true,
            merge_opts: {}, template: 'templates', vars: 'vars'
          }
        end
        it 'should render items correctly' do
          expect { cli.render }.to output(/rendertest.txt \[OK\]$/).to_stdout
          expect { cli.render }.to_not output(/ignoretest.txt/).to_stdout
          expect(FileUtils.compare_file(spec_merged, rendered_file)).to be_truthy
        end
      end

      context 'When a merge option is supplied' do
        before do
          cli.options = {
            extension: 'erb', ignore: 'rndrignore', merge: true,
            merge_opts: { 'overwrite_arrays' => 'true' }, template: 'templates', vars: 'vars'
          }
        end
        it 'should render items correctly' do
          expect { cli.render }.to output(/rendertest.txt \[OK\]$/).to_stdout
          expect { cli.render }.to_not output(/ignoretest.txt/).to_stdout
          expect(FileUtils.compare_file(spec_opts, rendered_file)).to be_truthy
        end
      end

      context 'When the replace merege strategy is specified' do
        before do
          cli.options = {
            extension: 'erb', ignore: 'rndrignore', merge: false,
            merge_opts: {}, template: 'templates', vars: 'vars'
          }
        end
        it 'should render items correctly' do
          expect { cli.render }.to output(/rendertest.txt \[OK\]$/).to_stdout
          expect { cli.render }.to_not output(/ignoretest.txt/).to_stdout
          expect(FileUtils.compare_file(spec_replaced, rendered_file)).to be_truthy
        end
      end

      context 'When provided an alternate extension' do
        before do
          cli.options = {
            extension: 'tmplt', ignore: 'rndrignore', merge: true,
            merge_opts: {}, template: 'templates', vars: 'vars'
          }
        end
        it 'should render items correctly' do
          expect { cli.render }.to output(/exttest.txt \[OK\]$/).to_stdout
          expect { cli.render }.to_not output(/rendertest.txt/).to_stdout
          expect(FileUtils.compare_file(spec_merged, rendered_ext)).to be_truthy
        end
      end
    end

    describe '#vars' do
      context 'When a directory is supplied.' do
        context 'should serialize and recursively merge variables' do
          before do
            cli.options = { format: 'yaml', merge: true, merge_opts: {}, vars: 'vars' }
            @merged = File.read(File.absolute_path('vars_merged.txt'))
          end
          it 'should perform a deep merge' do
            expect { cli.vars }.to output(@merged).to_stdout
          end
        end

        context 'should serialize and recursively merge variables with a merge option' do
          before do
            cli.options = {
              format: 'yaml', merge: true,
              merge_opts: { 'overwrite_arrays' => 'true' }, vars: 'vars'
            }
            @merged = File.read(File.absolute_path('vars_opts.txt'))
          end
          it 'should perform a deep merge' do
            expect { cli.vars }.to output(@merged).to_stdout
          end
        end

        context 'should serialize and merge variables with replace behaviour' do
          before do
            cli.options = { format: 'yaml', merge: false, merge_opts: {}, vars: 'vars' }
            @replaced = File.read(File.absolute_path('vars_replaced.txt'))
          end
          it 'should perform a standard merge' do
            expect { cli.vars }.to output(@replaced).to_stdout
          end
        end
      end

      context 'When a json file is supplied' do
        before do
          cli.options = { format: 'yaml', merge: true, merge_opts: {}, vars: 'vars/a.json' }
          @vars = File.read(File.absolute_path('vars_a.txt'))
        end
        it 'should serialize the data' do
          expect { cli.vars }.to output(@vars).to_stdout
        end
      end
      context 'When a yaml file is supplied' do
        before do
          cli.options = { format: 'yaml', merge: true, merge_opts: {}, vars: 'vars/b.yaml' }
          @vars = File.read(File.absolute_path('vars_b.txt'))
        end
        it 'should serialize the data' do
          expect { cli.vars }.to output(@vars).to_stdout
        end
      end
    end

    context '#version' do
      it 'should print the version string' do
        expect { cli.version }.to output(/Rndr Version: #{VERSION}$/).to_stdout
      end
    end
  end
end
# rubocop:enable Metris/ModuleLength
# rubocop:enable Metris/BlockLength

# -*- encoding: utf-8 -*-
# frozen_string_literal: true
# rubocop:disable Metrics/BlockLength
require 'json'
require 'rndr'
require 'rspec'
require 'yaml'
require_relative 'spec_helper'

module Rndr
  RSpec.describe Rndr do
    describe '#matches' do
      context 'When using the defaults' do
        let(:matched) { [File.absolute_path('templates/rendertest.txt.erb')] }
        let(:ignored) do
          [File.absolute_path('templates/ignoretest.txt.erb'),
           File.absolute_path('templates/failtest.txt.erb')]
        end
        subject(:results) { Rndr.matches(path: 'templates', ignore_path: 'rndrignore') }
        it 'should be an Array of filtered paths with default extension' do
          expect(results).to be_a(Array)
          expect(results).to match_array(matched)
        end
      end

      context 'When using an alternate extension' do
        let(:matched) { [File.absolute_path('templates/exttest.txt.tmplt')] }
        let(:ignored) do
          [File.absolute_path('templates/ignoretest.txt.erb'),
           File.absolute_path('templates/failtest.txt.erb')]
        end
        subject(:results) do
          Rndr.matches(path: 'templates', ext: 'tmplt', ignore_path: 'rndrignore')
        end
        it 'should be an Array of paths with alternate extension' do
          expect(results).to be_a(Array)
          expect(results).to match_array(matched)
        end
      end
    end

    describe '#read_vars' do
      context 'When a directory is supplied' do
        context 'should serialize and recursively merges variables' do
          let(:results) { YAML.load(File.read('vars_merged.txt')) }
          subject(:vars) { Rndr.read_vars(path: 'vars', merge: true) }
          it 'should perform a deep merge' do
            expect(vars).to eql(results)
          end
        end
        context 'should serialize and merge variables with replace behaviour' do
          let(:results) do
            YAML.load(File.read('vars_replaced.txt'))
          end
          subject(:vars) { Rndr.read_vars(path: 'vars', merge: false) }
          it 'should perform a standard merge' do
            expect(vars).to eql(results)
          end
        end
      end

      context 'When a json file is supplied' do
        let(:results) { JSON.parse(File.read('vars/a.json')) }
        subject(:vars) { Rndr.read_vars(path: 'vars/a.json', merge: true) }
        it 'should serialize the data' do
          expect(vars).to eql(results)
        end
      end

      context 'When a yaml file is supplied' do
        let(:results) { YAML.load(File.read('vars/b.yaml')) }
        subject(:vars) { Rndr.read_vars(path: 'vars/b.yaml', merge: true) }
        it 'should serialize the data' do
          expect(vars).to eql(results)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength

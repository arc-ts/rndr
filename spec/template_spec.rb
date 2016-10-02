# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require 'rndr'
require 'yaml'
require_relative 'spec_helper'

module Rndr
  RSpec.describe Template do
    before(:all) do
      Dir.chdir(File.join(Dir.pwd, 'test'))
      @success_tmplt = File.absolute_path('templates/rendertest.txt.erb')
      @fail_tmplt = File.absolute_path('templates/failtest.txt.erb')
      @rendered_success = File.absolute_path('templates/rendertest.txt')
      @rendered_fail = File.absolute_path('templates/failtest.txt')
      @compare_success = File.join(File.dirname(__FILE__), 'resources/rendered_merged.txt')
      @vars =
        YAML.load(File.read(File.join(File.dirname(__FILE__), 'resources/vars_merged.txt')))
    end
    after(:all) do
      Dir.chdir('../')
      File.delete(@rendered_success) if File.exist?(@rendered_success)
      File.delete(@rendered_fail) if File.exist?(@rendered_fail)
    end

    describe '#render?' do
      describe 'When the template is renderable' do
        subject { Template.new(path: @success_tmplt, vars: @vars).render? }
        it { is_expected.to be_truthy }
      end

      describe 'When the template is not renderable' do
        subject { Template.new(path: @fail_tmplt, vars: @vars).render? }
        it { is_expected.to be_falsey }
      end
    end

    describe '#render' do
      context 'When the template is renderable' do
        before(:all) { File.delete(@rendered_success) if File.exist?(@rendered_success) }
        subject { Template.new(path: @success_tmplt, vars: @vars).render(@rendered_success) }
        it { is_expected.to be_truthy }
        it 'should render file' do
          expect(File.exist?(@rendered_success)).to be_truthy
        end
        it 'should render contents correctly' do
          expect(FileUtils.compare_file(@rendered_success, @compare_success)).to be_truthy
        end
      end

      context 'When the template is not renderable' do
        before(:all) { File.delete(@rendered_fail) if File.exist?(@rendered_fail) }
        subject { Template.new(path: @fail_tmplt, vars: @vars).render(@rendered_fail) }
        it { is_expected.to be_falsey }
        it 'should not render file' do
          expect(File.exist?(@rendered_fail)).to be_falsey
        end
      end
    end
  end
end

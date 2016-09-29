# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require 'rndr'
require_relative 'spec_helper'

module Rndr
  RSpec.describe Template do
    before(:each) do
      Dir.chdir(File.join(Dir.pwd, 'test'))
    end

    after(:each) do
      Dir.chdir('../')
    end
    let(:template) { described_class.new }
  end
end

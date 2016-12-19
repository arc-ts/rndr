# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'coveralls/rake/task'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)
Coveralls::RakeTask.new

task default: :spec
task coveralls: [:spec, :features, 'coveralls:push']
RuboCop::RakeTask.new(:style) do |task|
  task.options << '--display-cop-names'
end

# -*- encoding: utf-8 -*-
# frozen_string_literal: true
require 'deep_merge'
require 'json'
require 'yaml'

module Rndr
  # Accepts a path (either file or directory), a file extension, and the name
  # of a file within the working directory that contains a list of file glob
  # patterns to be skipped. It returns an array of filtered matched paths.
  # @param path [String] The path to the template file or directory.
  # @param ext [String] The File name extension to identify template files.
  # @param ignore_path [String] The path to ignore file.
  # @return [Array<String>] list of paths to matching results.
  def self.matches(path:, ext: 'erb', ignore_path: File.join(Dir.pwd, '.rndrignore'))
    matched_paths = match_files(path: File.absolute_path(path), ext: ext)
    ignore_file_path = File.absolute_path(ignore_path)
    return filter_ignored_paths(path_list: matched_paths, ignore_path: ignore_file_path) if
           !matched_paths.empty? && File.exist?(ignore_file_path)
    matched_paths
  end

  # Accepts a file or directory and will attempt to parse the discovered file(s) as either json
  # or yaml. It will then be returned as a hash intended for use with seeding the binding used for
  # template rendering in {Template#render}.
  # @param path [String] The path to the vars file or directory. Will process both json and yaml.
  # @param merge [Boolean] True to enable recursive merge of hashes.
  # @param merge_opts [Hash] A hash of options to be passed to the deep_merge method
  # @return [Hash] A hash containing the processed variables. Will be used to send to the binding
  #    of a rendered template. See {Template#render} for more information.
  def self.read_vars(path:, merge: true, merge_opts: {})
    vars_path = File.absolute_path(path)
    return read_vars_file(vars_path) if File.file?(vars_path)
    return read_vars_dir(path: vars_path, merge: merge, merge_opts: merge_opts) if
           File.directory?(vars_path)
    {}
  end

  class << self
    private

    # @param path [String] Path to file or directory to test match condition.
    # @param ext [String] The extension to use as the match condition.
    # @return [Array<String>] Array of paths to matching files.
    def match_files(path:, ext:)
      return [path] if File.file?(path) && File.fnmatch("*#{ext}", path)
      if File.directory?(path)
        matched_paths = Dir["#{path}/**/*.#{ext}"]
        matched_paths.reject! { |file| File.directory?(file) }
        return matched_paths
      end
      []
    end

    # filter_ignored_paths removes paths from the supplied list if they match a
    # path within the supplied ignore_path.
    # @param path_list [Array<String>] Array of paths to matching files before prune
    #    from ignore_path.
    # @param ignore_path [String] Path to ignore file. Passed to @see #ignore_paths for
    #    processing.
    # @return [Array<String>] Pruned list of paths with files matching the glob patterns
    #    in ignore_path removed.
    def filter_ignored_paths(path_list:, ignore_path:)
      ignored_paths = ignore_paths(ignore_path)
      path_list.reject do |file|
        ignored_paths.any? do |ignore|
          File.fnmatch(ignore, file, File::FNM_PATHNAME)
        end
      end
    end

    # ignore_paths returns a list of paths used to filter possible discovered tempaltes
    # that should be ignored.
    # @param ignore_path [String] Path to ignore file.
    # @return [Array<String>] Generated list of paths to be ignored.
    def ignore_paths(ignore_path)
      ignore_list = File.readlines(ignore_path)
      ignore_list.map! { |line| line.chomp.strip }
      ignore_list.reject! { |line| line.empty? || line =~ /^(#|!)/ }
      ignore_list.map! { |line| File.absolute_path(line, File.dirname(ignore_path)) }
      ignore_list
    end

    # read_vars_file reads the data stored in file as supplied by path. processed_vars
    # json or yaml
    # @param path [String] Path to file with variables to be processed.
    # @return [Hash, nil] Hash of processed data read from var passed var file.
    def read_vars_file(path)
      data = File.read(path)
      return JSON.parse(data) if json?(data)
      return YAML.load(data) if yaml?(data)
      nil
    end

    # read_vars_dir combines all the variables within a supplied directory. It can injest
    # json or yaml.
    # @param path [String] Path to directory containing files to be ingested and vars
    #    processed.
    # @param merge [Boolean] True if variables from files should be recursively merged.
    # @param merge_opts [Hash] A hash of options to be passed to the deep_merge method
    # @return [Hash] Hash of processed variables read from files within the passed.
    def read_vars_dir(path:, merge:, merge_opts: {})
      processed_vars = {}
      Dir[File.join(path, '*')].each do |file|
        file_vars = read_vars_file(file)
        next if file_vars.nil?
        processed_vars =
          merge_vars(base_hash: processed_vars, hash: file_vars, merge: merge,
                     merge_opts: merge_opts)
      end
      processed_vars
    end

    # json? tests if the supplied json is parsable or not.
    # @param data [String] String containing read data from file.
    # @return [Boolean] True if data is valid json.
    def json?(data)
      JSON.parse(data)
      true
    rescue
      false
    end

    # yaml? tests if the supplied yaml is parsable or not.
    # @param data [String] String containing read data from file.
    # @return [Boolean] True if data is valid yaml.
    def yaml?(data)
      YAML.load(data)
      true
    rescue
      false
    end

    # to_bool converts the passed string to its associated bool value
    # @param value [String] String to be converted to bool value
    # @return [Boolean] True, False, or nil depending on input.
    def to_bool(value)
      return true if value.casecmp('true')
      return false if value.casecmp('false')
      nil
    end

    # deep_merge_opts converts the passed hash to the format that the deep_merge
    # function accepts.
    # @param hash [Hash] The options hash to be converted
    # @return [Hash] A converted options hash to be passed to the deep_merge method
    def deep_merge_opts(hash)
      opts = {}
      bool_vars = %w(extend_existing_arrays keep_array_duplicates merge_debug merge_hash_arrays
                     overwrite_arrays preserve_unmergeables sort_merged_arrays)
      string_vars = %w(knockout_prefix unpack_arrays)
      hash.each do |k, v|
        opts[k.to_sym] = v if string_vars.include?(k)
        opts[k.to_sym] = to_bool(v) if bool_vars.include?(k)
      end
      opts
    end

    # merge_vars handles merging hashes, either with a recursive merge (default) or with
    # a standard merge, which has a 'replace' effect.
    # @param base_hash [Hash] Original Hash to have values merged into.
    # @param hash [Hash] Secondary hash to be merged into base hash.
    # @param merge [Boolean] True to enable recursive merging of hashes.
    # @param merge_opts [Hash] A hash of options to be passed to the deep_merge method
    # @return [Hash] The merged hash.
    def merge_vars(base_hash:, hash:, merge: true, merge_opts: {})
      if base_hash.is_a?(Hash) && hash.is_a?(Hash)
        return base_hash.deep_merge!(hash, deep_merge_opts(merge_opts)) if
          merge == true
        return base_hash.merge!(hash) if merge == false
      end
      {}
    end
  end
end

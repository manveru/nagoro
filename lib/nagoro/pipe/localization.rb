$KCODE = 'UTF-8'
require 'fileutils'
require 'yaml'
require 'ya2yaml'

module Nagoro
  module Pipe
    class Localization
      attr_accessor :dict, :locale

      CONFIG = {
        :file => 'config/%s.yaml',
        :locales => %w[ en ],
        :default_language => 'en',
        :mapping => {'en-us' => 'en', 'ja' => 'jp'},
        :regex => /\[\[(.*?)\]\]/,
      }

      def self.[](conf = {})
        CONFIG.merge!(conf)
      end

      def initialize
        load_dictionary
      end

      def load_dictionary
        file = CONFIG[:file]
        files = CONFIG[:locales].map{|l| [l, file % l]}
        existing, missing = files.partition{|(l,f)| File.file?(f)}
        FileUtils.mkdir_p(File.dirname(file)) unless missing.empty?
        missing.each{|(l,f)| FileUtils.touch(f)}

        @dict = {}
        files.each do |locale, file|
          @dict[locale] = YAML.load_file(file) || {}
        end
      end

      def process(template)
        @template = template
        @template.gsub!(CONFIG[:regex]) do |e|
          localize($1)
        end
      end

      def localize(string)
        @dict[locale][string]
      end

      def to_html
        @template
      end

      def reset
        @template = ''
      end
    end
  end
end

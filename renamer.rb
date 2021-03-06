#!/usr/bin/env ruby
require 'yaml'
require 'optparse'

###################### CLI option parser ###############
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: renamer.rb [options]"
  opts.banner += "\nThis script will rename Quran surah files to include name"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-d", "--directory dir", "directory to look for files") do |dir|
    options[:directory] = dir
  end

  opts.on("-e", "--extension ext",
    "rename file with extension ext, without dot") do |ext|
    options[:extension] = ext
  end

  opts.on("-s", "--suffix string", "a suffix string to add after filename") do |suf|
    options[:suffix] = suf
  end
end.parse!

# extension is required
if options[:extension].nil?
  raise Kernel.abort("Error: Please specify extension with -e or --extension")
end

# extension is required
if options[:directory].nil?
  raise Kernel.abort("Error: Specify directory with -d or --directory")
end

##################### File rename ###############
script_dir = File.dirname File.realpath(__FILE__)
SURAH_DB = File.open(script_dir + "/surah_names.yml") { |file| YAML.load(file) }

directory = options[:directory] + (options[:directory][-1] == "/" ? '' : "/")
dotted_ext = "." + options[:extension]

Dir.glob(directory + "*" + dotted_ext) do |filename|
  s_number = filename.match(/[0-9]{1,3}/)[0]
  suffix = options[:suffix].nil? ? '' : '-' + options[:suffix]
  new_name = directory + s_number + "." + SURAH_DB[s_number.to_i] + suffix + dotted_ext

  begin
    if File.rename(filename, new_name).zero? # means success
      puts "#{filename} -> #{new_name}"
    end
  rescue SystemCallError
    puts "renamer: Failed to rename file! #{filename}"
  end
end

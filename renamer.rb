require 'yaml'
require 'optparse'
require 'fileutils'

###################### CLI option parser ###############
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: renamer.rb [options]"
  opts.banner += "\nThis script will rename Quran surah files to include name"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = v
  end

  opts.on("-e", "--extension ext",
    "rename file with extension ext, without dot") do |ext|
    options[:extension] = ext
  end
end.parse!

if options[:extension].nil?
  raise Kernel.abort("Error: Please specify extension with -e or --extension")
end

##################### File rename ###############
SURAH_DB = File.open("surah_names.yml") { |file| YAML.load(file) }
dotted_ext = "." + options[:extension]

Dir.glob('*' + dotted_ext ) do |filename|
  s_number = filename.match(/[0-9]{1,3}/)[0]
  new_name = s_number + "." + SURAH_DB[s_number.to_i] + dotted_ext
  puts "Renaming #{filename} to #{new_name}"
  FileUtils.mv(filename, new_name)
end

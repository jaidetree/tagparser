require 'optparse'

options = {}
htmlFiles = []

OptionParser.new do |opts|
    opts.banner = "Usage: opentags.rb [options]"
    
    options.on("-f", "--file", "HTML File input") do |file|
        htmlFiles << file
    end
end.parse!

p htmlFiles

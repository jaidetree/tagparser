#!/usr/bin/env ruby
require 'optparse'
require 'ostruct'

options = OpenStruct.new
options.htmlFiles = []
html = []

OptionParser.new do |opts|
    opts.banner = "Usage: opentags.rb [options]"
    
    opts.on("-f", "--file FILEPATH", "HTML File input") do |file|
        options.htmlFiles << file
    end
end.parse!

p options.htmlFiles

options.htmlFiles.each do |filename|
    file = File.open(filename, 'rb')
    html << file.read
    file.close
end

p html

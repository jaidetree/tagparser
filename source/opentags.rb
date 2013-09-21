#!/usr/bin/env ruby
###############################################################################
# Name: HTML Open Tag Finder
# Purpose: Finds unclosed HTML tags and shows them & line # on console. 
# Author: Jay Zawrotny <jayzawrotny@gmail.com>
# Date: September 21, 2013
# Version: 0.1
###############################################################################
# Requirements:
#   Ruby 2.0+
###############################################################################
# Notes:
#   If complexity grows, will be good to switch to Thor for arguments and
#   building.
#   TODO: Don't forget to refactor into classes!
###############################################################################
require 'optparse'
require 'ostruct'

options = OpenStruct.new  # Contains our options in a hash-like object.
options.htmlFiles = []  # Contains an array of filenames to read.
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

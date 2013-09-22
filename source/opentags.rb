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

options = OpenStruct.new    # Contains our options in a hash-like object.
options.htmlFiles = []      # Contains an array of filenames to read.
htmlContent = []            # Contains our array of HTML strings

# Uses Ruby 2.0 Option Parser
# Docs: http://ruby-doc.org/stdlib-2.0.0/libdoc/optparse/rdoc/OptionParser.html
OptionParser.new do |opts|
    opts.banner = "Usage: opentags.rb [options]"
    
    # For now we only need a filename
    opts.on("-f", "--file FILEPATH", "HTML File input") do |file|
        options.htmlFiles << file
    end
end.parse!

# For DEBUG only
# p options.htmlFiles

# Read each HTML file and store it
options.htmlFiles.each do |filename|
    file = File.open(filename, 'rb')
    htmlContent << file.read
    file.close
end

# For DEBUG only
# p htmlContent

# Main Application Functions
###############################################################################

# Loop through htmlContent array
def startParsing(htmlArray)
    htmlArray.each do |htmlString|
        tags = []                   # Contains the history of opened tags
        block = -1                  # Numeric counter for level within tags
        openTag = ""                # Currently open tag.
        errors = []                 # Array of errors to display
        parseHTML(htmlString, tags, block, openTag, errors)
    end
end

# Start searching through HTML
def parseHTML(htmlString, tags, block, openTag, errors)
    html = htmlString
    while html.length > 0 do
        index = html.index('<')
        if html.empty? or index.nil?
            html = ""
        else 
            html.slice!(0, index)
        end

        # look for nearest ">"
        endTagIndex = html.index('>')

        if endTagIndex.nil?
            next
        end

        tag = html.slice(1, endTagIndex - 1)

        if tag.slice(0).match(/\w/)
            startTag(tag, openTag, block, tags)
        elsif tag.slice(0) == "/"
            closeTag(tag, openTag, block, tags)
        end

        html.slice!(0, endTagIndex + 1)
    end
end

# Found Start tag
def startTag(tag, openTag, block, tags)
    block = block + 1 # we're inside a block
    openTag = tag
    tags << tag
end

# Found Closing tag
def closeTag(tag, openTag, block, tags)
    if tag != openTag
        # Raise error
        return
    end
    block = block + 1
    tags.pop()
    openTag = tags.last
end

# Raise Error
def raiseError(tag)
end

# Display Errors
def displayErrors(errors)
    return
end

# Runtime Logic
###############################################################################

startParsing(htmlContent)

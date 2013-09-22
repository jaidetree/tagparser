#!/usr/bin/env ruby
###############################################################################
# Name: HTML Closed Tag Finder
# Purpose: Finds unclosed HTML tags and shows them & line # on console. 
# Author: Jay Zawrotny <jayzawrotny@gmail.com>
# Date: September 21, 2013
# Version: 0.1
# License: GPLv3 <http://www.gnu.org/licenses/gpl-3.0.html>
###############################################################################
# Requirements:
#   Ruby 2.0+
###############################################################################
# Notes:
#   If complexity grows, will be good to switch to Thor for arguments and
#   building.
###############################################################################
require 'optparse'
require 'ostruct'

# Get CLI options
class CLIArgParser
    @options = nil
    
    def initialize
        @options = OpenStruct.new    # Contains our options in a hash-like object.
        @options.htmlFiles = []      # Contains an array of filenames to read.

        # Uses Ruby 2.0 Option Parser
        # Docs: http://ruby-doc.org/stdlib-2.0.0/libdoc/optparse/rdoc/OptionParser.html
        OptionParser.new do |opts|
            opts.banner = "Usage: opentags.rb [options]"
            
            # For now we only need a filename
            opts.on("-f", "--file FILEPATH", "HTML File input") do |file|
                options.htmlFiles << file
            end
        end.parse!
    end

    def options
        return @options
    end

    def files
        return @options.htmlFiles
    end
end

# Manages retrieving & storing the HTML in an array
class HTMLFileManager
    def initialize(args)
        @html = []
        # Read each HTML file and store it
        args.files.each do |filename|
            file = File.open(filename, 'rb')
            @html << file.read
            file.close
        end
    end

    def html
        return @html
    end
end

# Main Application Functions
###############################################################################

class ClosedTagFinder

    # Loop through htmlContent array
    def initialize(htmlFiles)
        @tags = []                   # Contains the history of opened tags
        @block = 0                   # Numeric counter for level within tags
        @openTag = ""                # Currently open tag.
        @errors = []                 # Array of errors to display
        @selfClosingTags = "area,base,basefont,br,col,frame,hr,img,input,isindex,link,meta,param,embed".split(',')

        htmlFiles.html.each do |htmlString|
            @errors = []
            parseHTML(htmlString)
            displayErrors()
        end
    end

    # Start searching through HTML
    def parseHTML(htmlString)
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

            # Grab "<[this part]>" form in between our first match of "<" and first match of ">"
            tag = html.slice(1, endTagIndex - 1)

            
            if tag.match(/^!\-\-/)
                testIndex = html.index('-->')
                html.slice!(0, testIndex + 3)
                next
            elsif tag.slice(0).match(/\w/)  # If tag starts with a letter, it's an open tag
                startTag(tag)
            elsif tag.slice(0) == "/"  # If tag starts with a "/" it's a closing tag.
                closeTag(tag)
            end

            html.slice!(0, endTagIndex + 1)
        end
    end

    # Found Start tag
    def startTag(tag)
        tag = tag.split(' ').first
        if tag.match(/\/$/) or @selfClosingTags.include?(tag)  # Ignore self closing tags.
            return
        end
        @block += 1 # we're inside a block
        @openTag = tag
        @tags << tag
        # puts "Opening tag: " + tag + ':' + @block.to_s
    end

    # Found Closing tag
    def closeTag(tag)
        tag.slice!(0)
        # puts "|-------Closing tag: " + tag + ':' + @block.to_s
        @block -= 1

        if @openTag == tag
            @tags.pop()
        else
            raiseError(tag)
            @tags.pop(2)
        end

        @openTag = @tags.last
    end

    # Raise Error
    def raiseError(tag)
        @errors << "Found </" + tag + "> expected </" + @openTag.to_s + ">"
    end

    # Display Errors
    def displayErrors()
        if @errors.empty?
            puts "There were no incomplete tags found."
        else
            @errors.each do |e|
                puts e
            end
        end
    end
end

# Runtime Logic
###############################################################################

# options = CLIArgParser.new
# htmlfiles = HTMLFileManager.new(options.files)
# ClosedTagFinder.new(htmlfiles.html)

# ClosedTagFinder.new(HTMLFileManager.new(CLIArgParser.new()))

options = CLIArgParser.new
htmlFiles = HTMLFileManager.new(options)
ClosedTagFinder.new(htmlFiles)

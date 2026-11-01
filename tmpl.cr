require "option_parser"
require "./tmpllib"
require "./tmplprompt"

VERSION = {{ env("VERSION") || "unknown" }}

parser = OptionParser.new do |p|
  p.banner = "tmpl"

  p.on("-v", "--version", "Show version") do
    puts "tmpl #{VERSION}"
    exit
  end

  p.on("-h", "--help", "Show help message") do
    puts p
    exit
  end

  p.invalid_option do |flag|
    abort "tmpl: unknown option #{flag}\n\n#{p}"
  end
end

parser.parse

entries = read_entries()
names = extract_template_names(entries)
abort "tmpl: no templates found" if names.empty?

name = ARGV.shift? || select_prompt(names)
dest = ARGV.shift? || input_prompt("output", ".")
expand(entries, name, dest)

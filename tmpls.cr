require "option_parser"
require "./tmplslib"

parser = OptionParser.new do |p|
  p.banner = "tmpls"

  p.on("-h", "--help", "Show help message") do
    puts p
    exit
  end

  p.invalid_option do |flag|
    abort "tmpls: unknown option #{flag}\n\n#{p}"
  end
end

parser.parse

entries = read_entries()
names = extract_template_names(entries)
abort "tmpls: no templates found" if names.empty?

name = ARGV.shift? || select_prompt(names)
dest = ARGV.shift? || name
expand(entries, name, dest)
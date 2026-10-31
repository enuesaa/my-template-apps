require "./tmplslib"

entries = read_entries()
names = extract_template_names(entries)
abort "tmpls: no templates found" if names.empty?

name = ARGV.shift? || select_prompt(names)
dest = ARGV.shift? || name
expand(entries, name, dest)

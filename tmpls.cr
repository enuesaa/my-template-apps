require "http/client"
require "compress/zip"
require "uri"

REPO = "enuesaa/tmpls"
REF  = "main"

record Entry, rel : String, type : Char, linkname : String, mode : Int32, data : Bytes

def fetch(url : String, limit = 5)
  abort "tmpls: too many redirects" if limit.zero?
  HTTP::Client.get(url) do |res|
    case res.status_code
    when 200..299
      io = IO::Memory.new
      IO.copy(res.body_io, io)
      io.rewind
      return io
    when 300..399
      loc = res.headers["Location"]? || abort("tmpls: redirect without location")
      return fetch(URI.parse(url).resolve(loc).to_s, limit - 1)
    else
      abort "tmpls: failed to fetch #{url} (#{res.status_code})"
    end
  end
end

def read_entries(ref : String) : Array(Entry)
  body = fetch("https://codeload.github.com/#{REPO}/zip/#{ref}")
  entries = [] of Entry

  Compress::Zip::File.open(body) do |zip|
    zip.entries.each do |e|
      rel = e.filename.split("/", 2)[1]?
      next if rel.nil? || rel.empty?

      if e.dir?
        entries << Entry.new(rel, '5', "", 0o755, Bytes.empty)
      else
        io = IO::Memory.new
        e.open { |f| IO.copy(f, io) }
        entries << Entry.new(rel, '0', "", 0o644, io.to_slice)
      end
    end
  end
  entries
end

def template_names(entries : Array(Entry)) : Array(String)
  entries
    .map(&.rel)
    .select { |rel| rel.includes?("/") && !rel.starts_with?(".") }
    .map { |rel| rel.split("/").first }
    .uniq
    .sort
end

def read_key : String
  key = ""
  STDIN.raw do
    if b = STDIN.read_byte
      key = String.build do |io|
        io.write_byte b
        if b == 27_u8
          2.times { if c = STDIN.read_byte; io.write_byte c; end }
        end
      end
    end
  end
  key
end

def select_prompt(items : Array(String)) : String
  cursor = 0
  first = true
  print "\e[?25l"

  loop do
    print "\e[#{items.size}A" unless first
    first = false

    items.each_with_index do |item, i|
      print "\e[2K\r"
      puts i == cursor ? "> #{item}" : "  #{item}"
    end

    case read_key
    when "\e[A" then cursor = (cursor - 1) % items.size
    when "\e[B" then cursor = (cursor + 1) % items.size
    when "\r", "\n"
      selected = items[cursor]
      print "\e[#{items.size}A\e[2K\r> #{selected}\n"
      (items.size - 1).times { print "\e[2K\n" }
      print "\e[#{items.size - 1}A"
      print "\e[?25h"
      return selected
    when "\u0003"
      print "\e[?25h"
      exit 1
    end
  end
end

def extract(entries : Array(Entry), name : String, dest : String)
  prefix = "#{name}/"
  targets = entries.select { |e| e.rel.starts_with?(prefix) && e.rel != prefix }
  abort "tmpls: template '#{name}' not found" if targets.empty?

  targets.each do |e|
    sub = e.rel.lchop(prefix)
    abort "tmpls: unsafe path #{sub}" if sub.split("/").includes?("..")
    path = File.join(dest, sub)

    if e.type == '5'
      Dir.mkdir_p(path)
    else
      Dir.mkdir_p(File.dirname(path))
      if File.exists?(path)
        puts "skip  #{path}"
      else
        File.open(path, "w") { |f| f.write(e.data) }
        File.chmod(path, e.mode & 0o777)
        puts "write #{path}"
      end
    end
  end
end

entries = read_entries(REF)
names = template_names(entries)
abort "tmpls: no templates found" if names.empty?

name = ARGV.shift? || select_prompt(names)
dest = ARGV.shift? || "."
extract(entries, name, dest)

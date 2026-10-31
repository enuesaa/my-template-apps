require "http/client"
require "compress/zip"
require "uri"

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

record Entry,
  path : String,
  dir : Bool,
  mode : Int32,
  data : Bytes

def read_entries : Array(Entry)
  body = fetch("https://github.com/enuesaa/tmpls/releases/latest/download/templates.zip")
  entries = [] of Entry

  Compress::Zip::File.open(body) do |zip|
    zip.entries.each do |e|
      path = e.filename
      next if path.empty?

      if e.dir?
        entries << Entry.new(path: path, dir: true, mode: 0o755, data: Bytes.empty)
      else
        io = IO::Memory.new
        e.open { |f| IO.copy(f, io) }
        entries << Entry.new(path: path, dir: false, mode: 0o644, data: io.to_slice)
      end
    end
  end
  entries
end

def extract_template_names(entries : Array(Entry)) : Array(String)
  entries
    .map(&.path)
    .select { |path| path.includes?("/") && !path.starts_with?(".") }
    .map { |path| path.split("/").first }
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

def expand(entries : Array(Entry), name : String, dest : String)
  prefix = "#{name}/"
  targets = entries.select { |e| e.path.starts_with?(prefix) && e.path != prefix }
  abort "tmpls: template '#{name}' not found" if targets.empty?

  targets.each do |e|
    sub = e.path.lchop(prefix)
    abort "tmpls: unsafe path #{sub}" if sub.split("/").includes?("..")
    path = File.join(dest, sub)

    if e.dir
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

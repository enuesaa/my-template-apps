require "compress/zip"
require "base64"

{% begin %}
  {% dirs = "laravel nextjs python svelte workers" %}
  {% list = "git ls-files -co --exclude-standard -- " + dirs %}
  {% pack = "zip -q - -@ | base64 | tr -d '\\n'" %}
  {% zip_b64 = `cd #{__DIR__} && #{list.id} | #{pack.id}` %}

  TEMPLATES_ZIP_B64 = {{ zip_b64.stringify }}
{% end %}

record Entry,
  path : String,
  dir : Bool,
  mode : Int32,
  data : Bytes

def read_entries : Array(Entry)
  body = IO::Memory.new(Base64.decode(TEMPLATES_ZIP_B64))
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

def expand(entries : Array(Entry), name : String, dest : String)
  prefix = "#{name}/"
  targets = entries.select { |e| e.path.starts_with?(prefix) && e.path != prefix }
  abort "tmpl: template '#{name}' not found" if targets.empty?

  targets.each do |e|
    sub = e.path.lchop(prefix)
    abort "tmpl: unsafe path #{sub}" if sub.split("/").includes?("..")
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

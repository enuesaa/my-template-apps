record Entry,
  path : String,
  mode : Int32,
  data : Bytes

ENTRIES = {% begin %}
  [
    {% dirs = "laravel nextjs python svelte workers" %}
    {% files = `cd #{__DIR__} && git ls-files -co --exclude-standard -- #{dirs.id}`.lines %}
    {% for f in files %}
      Entry.new(
        path: {{ f }},
        mode: File.info({{ __DIR__ + "/" + f }}).permissions.value.to_i32,
        data: {{ read_file(__DIR__ + "/" + f) }}.to_slice,
      ),
    {% end %}
  ] of Entry
{% end %}

def extract_template_names : Array(String)
  ENTRIES.map { |e| e.path.split("/").first }.uniq.sort
end

def expand(name : String, dest : String)
  prefix = "#{name}/"
  targets = ENTRIES.select { |e| e.path.starts_with?(prefix) }
  abort "tmpl: template '#{name}' not found" if targets.empty?

  targets.each do |e|
    sub = e.path.lchop(prefix)
    abort "tmpl: unsafe path #{sub}" if sub.split("/").includes?("..")
    path = File.join(dest, sub)

    Dir.mkdir_p(File.dirname(path))
    if File.exists?(path)
      puts "skip  #{path}"
    else
      File.write(path, e.data)
      puts "write #{path}"
    end
  end
end

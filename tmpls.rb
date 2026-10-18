#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "io/console"
require "net/http"
require "rubygems/package"
require "zlib"

REPO = "enuesaa/tmpls"
REF  = "main"

def fetch(url, limit = 5)
  abort "tmpls: too many redirects" if limit.zero?
  res = Net::HTTP.get_response(URI(url))
  case res
  when Net::HTTPSuccess     then res.body
  when Net::HTTPRedirection then fetch(res["location"], limit - 1)
  else abort "tmpls: failed to fetch #{url} (#{res.code})"
  end
end

def read_entries(ref)
  body = fetch("https://codeload.github.com/#{REPO}/tar.gz/#{ref}")
  gz   = Zlib::GzipReader.new(StringIO.new(body))
  Gem::Package::TarReader.new(gz).each_with_object([]) do |entry, list|
    rel = entry.full_name.split("/", 2)[1]
    next if rel.nil? || rel.empty?
    list << { rel: rel, header: entry.header, data: entry.read }
  end
end

def template_names(entries)
  entries
    .map    { |e| e[:rel] }
    .select { |rel| rel.include?("/") && !rel.start_with?(".") }
    .map    { |rel| rel.split("/").first }
    .uniq
    .sort
end

def read_key
  key = $stdin.getch
  if key == "\e"
    begin
      key << $stdin.read_nonblock(2)
    rescue IO::WaitReadable
    end
  end
  key
end

def select_prompt(items)
  cursor = 0
  first  = true
  $stdout.print "\e[?25l"

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
      $stdout.print "\e[?25h"
      return selected
    when "\u0003"
      $stdout.print "\e[?25h"
      abort
    end
  end
end

def extract(entries, name, dest)
  prefix  = "#{name}/"
  targets = entries.select { |e| e[:rel].start_with?(prefix) && e[:rel] != prefix }
  abort "tmpls: template '#{name}' not found" if targets.empty?

  targets.each do |e|
    sub  = e[:rel].delete_prefix(prefix)
    abort "tmpls: unsafe path #{sub}" if sub.split("/").include?("..")
    path = File.join(dest, sub)

    if e[:header].typeflag == "5"
      FileUtils.mkdir_p(path)
    elsif e[:header].typeflag == "2"
      FileUtils.mkdir_p(File.dirname(path))
      File.symlink(e[:header].linkname, path) unless File.exist?(path)
    else
      FileUtils.mkdir_p(File.dirname(path))
      if File.exist?(path)
        puts "skip  #{path}"
      else
        File.binwrite(path, e[:data])
        File.chmod(e[:header].mode & 0o777, path)
        puts "write #{path}"
      end
    end
  end
end

entries = read_entries(REF)
names   = template_names(entries)
abort "tmpls: no templates found" if names.empty?

name = ARGV.shift
name = select_prompt(names) if name.nil?

dest = ARGV.shift || "."
extract(entries, name, dest)

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

    key = read_key
    case key
    when "\e[A", "\eOA", "k" then cursor = (cursor - 1) % items.size
    when "\e[B", "\eOB", "j" then cursor = (cursor + 1) % items.size
    when "\r", "\n"
      selected = items[cursor]
      print "\e[#{items.size}A\e[2K\r> #{selected}\n"
      (items.size - 1).times { print "\e[2K\n" }
      print "\e[#{items.size - 1}A"
      print "\e[?25h"
      STDOUT.flush
      return selected
    when "\u0003"
      print "\e[?25h"
      STDOUT.flush
      exit 1
    end
  end
end

def input_prompt(label : String, default : String) : String
  print "#{label} (#{default}): "
  STDOUT.flush
  line = gets
  value = line.try(&.strip) || ""
  value.empty? ? default : value
end

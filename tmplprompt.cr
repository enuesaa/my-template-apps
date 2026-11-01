def read_key : Symbol
  key = :other

  STDIN.raw do
    case STDIN.read_byte
    when nil, 3
      key = :quit
    when 13, 10
      key = :enter
    when 27
      STDIN.read_byte
      case STDIN.read_byte
      when 'A'.ord then key = :up
      when 'B'.ord then key = :down
      end
    end
  end

  key
end

def draw_menu(items : Array(String), cursor : Int32)
  items.each_with_index do |item, i|
    print "\e[2K\r" # clear line
    puts "#{i == cursor ? "> " : "  "}#{item}"
  end
end

def select_prompt(items : Array(String)) : String
  cursor = 0
  draw_menu(items, cursor)

  loop do
    case read_key
    when :up    then cursor = (cursor - 1) % items.size
    when :down  then cursor = (cursor + 1) % items.size
    when :enter then break
    when :quit  then exit 1
    end

    print "\e[#{items.size}A" # move up to menu top
    draw_menu(items, cursor)
  end

  print "\e[#{items.size}A" # move up to menu top
  print "\e[J"              # clear below
  puts "> #{items[cursor]}"
  items[cursor]
end

def input_prompt(label : String, default : String) : String
  buffer = default

  loop do
    print "\r\e[2K#{label}: #{buffer}" # redraw line
    STDOUT.flush

    byte = STDIN.raw { STDIN.read_byte }

    case byte
    when nil, 3
      puts
      exit 1
    when 13, 10
      puts
      return buffer
    when 127, 8
      buffer = buffer.rchop
    when 32..126
      buffer += byte.chr.to_s
    end
  end
end

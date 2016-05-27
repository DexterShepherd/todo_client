#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'colorize'

todo_path = ENV['TODO_PATH']
if File.read(todo_path).empty?
  File.open(todo_path, 'w'){|f| f.write([{task: 'dummy', status: 'done'},{task: 'dummy', status: 'done'}].to_json)}
end
@todos = JSON.parse(File.read(todo_path))

def print_open(notes=nil)
  open = @todos.select do |i|
    i['status'] == "open"
  end
  puts "===================================="
  open.each_with_index do |val, index|
    print "#{index} | "
    print "#{val['status']}".colorize(:red)
    print " | "
    puts "#{val['task']}".colorize(:blue)
    if notes
      val["notes"].each do |i|
        puts "            - #{i}"
      end
    end
  end
  puts "===================================="
end

def print_all
  puts "===================================="
  @todos.each_with_index do |val, index|
    print "#{index} | "
    val['status'] == 'done' ? color = :light_blue : color = :red
    print "#{val['status']}".colorize(color)
    print " | "
    puts "#{val['task']}".colorize(:blue)
  end
  puts "===================================="
end

OptionParser.new do |parser|
  parser.on("-a", "--add TODO", "The todo to be added") do |a|
    @todos.unshift({"task" => a, "status" => "open", "notes" => []})
    print_open
  end

  parser.on("-i", "--index INDEX", Integer, "select todo[INDEX] to operate on") do |i| 
    @selected = @todos[i]
  end

  parser.on("-c", "--complete [INDEX]", Integer, "complete selected" ) do |c|
    if !@selected.nil? 
      puts "not nil"
      @selected['status'] = "done" 
    else
      @todos[c]['status'] = "done"
    end
    print_open
  end

  parser.on("-n", "--note NOTE", "add NOTE to seleced todo" ) do |n|
    @selected['notes'].push(n) unless @selected.nil?
    print_open
  end


  parser.on("-l", "--list [n]", "List open todos") do |l|
    print_open(l)
  end

  parser.on("--all", "list all todos") do |a|
    print_all
  end
end.parse!

@todos = @todos.sort do |a,b|
  if a["status"] == "open" && b["status"] == "done"
    -1
  elsif a["status"] == "done" && b["status"] == "open"
    1
  else
    0
  end
end

File.open(todo_path, 'w') {|f| f.write(@todos.select{|i| i['task'] != 'dummy'}.to_json)}


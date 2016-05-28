#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'colorize'

todo_path = ENV['TODO_PATH']

default = {
  list: "inbox",
  inbox: [
    {task: 'dummy', status: 'done'},
    {task: 'dummy', status: 'done'}
  ]
}

if File.read(todo_path).empty?
  File.open(todo_path, 'w'){|f| f.write(default.to_json)}
end

@db = JSON.parse(File.read(todo_path))
@todos = @db[@db['list']]

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

  parser.on("--lists", "show all lists") do |l|
    @db.each do |key, val|
      puts key unless key == "list"
    end
  end

  parser.on("--add_list LIST", "add a new list named LIST") do |l|
    @todos = [
      {task: 'dummy', status: 'done'},
      {task: 'dummy', status: 'done'}
    ]
    @db['list'] = l
  end

  parser.on("-s", "--swtich [list]", "swtitch to LIST") do |s|
    if @db.key? s 
      @db['list'] = s
      @todos = @db[@db['list']]
    else
      puts "no list #{s} in db"
    end
  end

  parser.on("--delete LIST", "delete LIST") do |d|
    if @db['list'] == d
      @db.list = @db.keys[1]
      @db = @db.select{|key, val| key.to_s != @db[d]}
    else
      @db = @db.select{|key, val| key.to_s != @db[d]}
    end
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

@db[@db['list']] = @todos.select{ |i| i['task'] != 'dummy'}

File.open(todo_path, 'w'){|f| f.write(@db.to_json)}

#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'colorize'

todo_path = ENV['TODO_PATH']
todos = JSON.parse(File.read(todo_path))

OptionParser.new do |parser|
  parser.on("-n", "--new TODO", "The todo to be added") do |t|
    todos.unshift({task: t, status: "open"})
  end

  parser.on("-c", "--complete INDEX", "The index of the item to complete" ) do |c|
    todos[c.to_i]['status'] = "done"
  end

  parser.on("-l", "--list", "List open todos") do |l|
    open = todos.select do |i|
      i['status'] == "open"
    end
    open.each_with_index do |val, index|
      puts "---"
      print "#{index} | "
      print "#{val['status']}".colorize(:red)
      print " | "
      puts "#{val['task']}".colorize(:blue)
    end
  end

  parser.on("-a", "--all", "list all todos") do |a|
    todos.each_with_index do |val, index|
      puts "---"
      print "#{index} | "
      val['status'] == 'done' ? color = :red : color = :light_blue
      print "#{val['status']}".colorize(color)
      print " | "
      puts "#{val['task']}".colorize(:blue)
    end
  end

end.parse!

File.open(todo_path, 'w') {|f| f.write(todos.to_json)}


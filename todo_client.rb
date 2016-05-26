#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'colorize'

todo_path = ENV['TODO_PATH']
if File.read(todo_path).empty?
  File.open(todo_path, 'w'){|f| f.write([{task: 'dummy', status: 'done'},{task: 'dummy', status: 'done'}].to_json)}
end
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
      puts ""
      print "#{index} | "
      print "#{val['status']}".colorize(:red)
      print " | "
      puts "#{val['task']}".colorize(:blue)
      puts ""
    end
  end

  parser.on("-a", "--all", "list all todos") do |a|
    r = todos.sort do |a,b|
      if a["status"] == "open" && b["status"] == "done"
        -1
      elsif a["status"] == "done" && b["status"] == "open"
        1
      else
        0
      end
    end

    puts r

    r.each_with_index do |val, index|
      puts ""
      print "#{index} | "
      val['status'] == 'done' ? color = :light_blue : color = :red
      print "#{val['status']}".colorize(color)
      print " | "
      puts "#{val['task']}".colorize(:blue)
      puts ""
    end
  end
end.parse!

File.open(todo_path, 'w') {|f| f.write(todos.select{|i| i['task'] != 'dummy'}.to_json)}


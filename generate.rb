#!/usr/bin/env ruby

puts "Reading zabbix_agent.template.plg..."
input = File.read("./zabbix_agent.template.plg")

output = input.gsub(/{{{ (.+) }}}/) do
	puts "Including #{$1}..."
	File.read($1)
end
puts "Writing zabbix_agent.plg..."
File.write("./zabbix_agent.plg", output)
puts "Done."

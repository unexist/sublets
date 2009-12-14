#
# Clock
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the clock
# Version: 0.2
# Date: Sat Sep 13 19:00 CET 2008
# Tags: Icon DSL
#

require "subtle/subtlext"

configure :clock do |s|
  s.interval = 10
  s.icon     = Subtle::Icon.new(ENV["XDG_DATA_HOME"] + "/icons/clock.xbm")
  s.win      = Subtlext::Window.new("info", [ 50, 50, 50, 50 ], "#ffffff", "#202020", "#303030")
end

on :mouse_down do |s, x, y, button|
  puts "%s: mouse click %d/%d with button %d" % [ s.name, x, y, button ]
end

on :mouse_over do |s|
  s.background = "#aa0000"
  s.win.map
end

on :mouse_out do |s|
  s.background = "#202020"
  s.win.unmap
end

on :run do |s|
  s.data = s.icon + Time.now().strftime("%y/%m/%d %H:%M:%S")
end

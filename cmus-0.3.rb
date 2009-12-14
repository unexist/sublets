#
# Cmus
#
# Author: Brandon Hartshorn
# Contact: sharntehnub@gmail.com
# Description: Shows what song is currently playing in cmus
# Version: 0.3
# Date: Sat Nov 14 13:13 MST 2009
# Tags: Notify DSL
#

configure :cmus do |s|
  s.file = "/tmp/cmus-status"

  s.watch(s.file)
end

on :run do |s|
  begin 
    s.data = IO.readlines(s.file).first.chop
  rescue => err
    puts err
    s.data = "[BROKE]"
  end
end 

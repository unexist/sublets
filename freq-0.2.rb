#
# Freq
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the cpu frequence
# Version: 0.2
# Date: Mon May 18 21:00 CET 2009
# Tags: Proc Multicore DSL
#

configure :freq do |s|
  s.interval = 120
end

on :run do |s|
  begin
    data = ""
    file = IO.readlines("/proc/cpuinfo").join

    file.scan(/cpu MHz\s+:\s+([0-9.]+)/) do |freq| 
      data << freq.first.to_i.to_s + " Mhz "
    end

    s.data = data.chop
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end  
end

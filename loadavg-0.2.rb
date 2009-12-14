#
# Loadavg
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the loadavg
# Version: 0.2
# Date: Sat Sep 13 19:00 CET 2008
# Tags: Proc
#

configure :loadavg do |s|
  s.interval = 30
end

on :run do |s|
  file = ""

  begin
    File.open("/proc/loadavg", "r") do |f|
      file = f.read
    end

    s.data = file.slice(0, 14)
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end

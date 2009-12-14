#
# Notify
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Notify example
# Version: 0.2
# Date: Sat Sep 13 19:00 CET 2008
# Tags: Notify DSL
#

configure :notify do |s|
  s.file = ENV["HOME"] + "/notify.log"

  s.watch(s.file)
end

on :run do |s|
  begin
    s.data = File.readlines(s.file).to_s.chop
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end  
end

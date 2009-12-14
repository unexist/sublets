#
# Storage
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the storage usage
# Version: 0.2
# Date: Mon May 18 21:00 CET 2009
# Tags: DSL
#

configure :storage do |s|
  s.interval = 120
  s.left     = 0
  s.total    = 0
end

on :run do |s|
  report = ""

  begin
    report = `df -h`
    s.total, s.left = report.match(/([0-9.]+.)\s+[0-9.]+.\s+([0-9.]+.)\s+[0-9.]+%\s+\/\s+/).captures

    s.data = s.left + "/" + s.total
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end

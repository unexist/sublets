#
# Temp
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the cpu temperature
# Version: 0.2
# Date: Mon May 18 21:00 CET 2009
# Tags: Proc DSL
#

configure :temp do |s|
  s.interval = 60
  s.temp     = ""
  s.icon     = Subtle::Icon.new(ENV["XDG_DATA_HOME"] + "/icons/temp.xbm")

  begin
    s.path = Dir["/proc/acpi/thermal_zone/*"][0] #< Get temp slot
  rescue => err
    err
  end
end

on :run do |s|
  begin
    file = ""

    # Read temp state file
    File.open(s.path + "/temperature", "r") do |f|
      file = f.read
    end

    s.temp = file.match(/temperature:\s+(\d+)/).captures.first

    s.data = s.icon + s.temp.to_s + "C "
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end

# Battery specification file
# Created with sur-0.1
Sur::Specification.new do |s|
  s.name        = "Battery"
  s.authors     = [ "Christoph Kappel" ]
  s.date        = "Sat Sep 53 12:00 CET 2008"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Show the battery state"
  s.version     = "0.3"
  s.tags        = [ "Sys", "Icon" ]
  s.files       = [ "battery.rb" ]
  s.icons       = [ 
    "icons/ac.xbm",
    "icons/bat_full_02.xbm",
    "icons/bat_low_02.xbm",
    "icons/bat_empty_02.xbm"
  ]
end

# Dbus specification file
# Created with sur-0.1.113
Sur::Specification.new do |s|
  s.name        = "Dbus"
  s.authors     = [ "unexist" ]
  s.date        = "Tue Feb 02 20:19 CET 2010"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Display libnotify messages"
  s.version     = "0.0"
  s.tags        = [ ]
  s.files       = [ "dbus.rb" ]
  s.icons       = [ ]

  s.add_dependency("ffi", ">=0.5.4")
end

# Dbus specification file
# Created with sur-0.1.113
Sur::Specification.new do |s|
  s.name             = "Notify"
  s.authors          = [ "unexist" ]
  s.date             = "Tue Feb 02 20:19 CET 2010"
  s.contact          = "unexist@dorfelite.net"
  s.description      = "Display libnotify messages"
  s.notes            = <<NOTES
NOTES
  s.version          = "0.4"
  s.tags             = [ "FFI", "DBus", "Libnotify", "Icon", "Window" ]
  s.files            = [ "notify.rb" ]
  s.icons            = [ "icons/info.xbm" ]
  s.subtlext_version = "0.9.2127"
  s.sur_version      = "0.2.168"

  s.add_dependency("ffi", ">=0.5.4")
end

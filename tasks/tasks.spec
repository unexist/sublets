# Tasks specification file
# Created with sur-0.1
Sur::Specification.new do |s|
  s.name        = "Tasks"
  s.authors     = [ "Christoph Kappel" ]
  s.date        = "Tue Dec 1 23:00 CET 2009"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Show visible clients"
  s.notes       = <<NOTES
This sublet displays all visible clients in a tasklist like fashion. Current
client is highlighted and a click on a client name will focus it.

Configurable settings: color_separator (String), color_active (String),
                       color_inactive (String), separator (String)
NOTES
  s.version     = "0.31"
  s.tags        = [ "Mouse" ]
  s.files       = [ "tasks.rb" ]
  s.icons       = [ ]
end

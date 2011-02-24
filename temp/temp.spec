# Temp specification file
# Created with sur-0.1
Sur::Specification.new do |s|
  # Sublet information
  s.name        = "Temp"
  s.version     = "0.32"
  s.tags        = [ "Sys", "Icon" ]
  s.files       = [ "temp.rb" ]
  s.icons       = [ "icons/temp.xbm" ]

  # Sublet description
  s.description = "Show the temperature"
  s.notes       = <<NOTES
This sublet just displays the current temperature.
NOTES

  # Sublet authors
  s.authors     = [ "Christoph Kappel" ]
  s.contact     = "unexist@dorfelite.net"
  s.date        = "Mon May 18 21:00 CET 2009"
end

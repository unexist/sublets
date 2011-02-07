# -*- encoding: utf-8 -*-
# Fuzzytime specification file
# Created with sur-0.2
Sur::Specification.new do |s|
  s.name        = "Fuzzytime"
  s.authors     = [ "unexist" ]
  s.date        = "Mon Feb 07 13:03 CET 2011"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Display time in fuzzy strings"
  s.notes       = <<NOTES
This sublet displays the time in strings that describe the time rather than
displaying the actual time. Instead of something like '15:50' it displays
'ten to four'.

Currently only en and de locales are supported, if your locale is missing
just let me know.
NOTES
  s.config      = {
    {
      :name        => "locale",
      :type        => "string",
      :description => "Localization of the text",
      :def_Value   => "en"
      }
  }
  s.version     = "0.0"
  s.tags        = [ "Localization" ]
  s.files       = [ "fuzzytime.rb" ]
  s.icons       = [ ]
end

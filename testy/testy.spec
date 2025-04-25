# -*- encoding: utf-8 -*-
# Testy specification file
# Created with sur-0.2
Sur::Specification.new do |s|
  s.name        = "Testy"
  s.authors     = [ "unexist" ]
  s.date        = "Mon Sep 27 22:07 CEST 2010"
  s.contact     = "christoph@unexist.dev"
  s.description = "Simple event and hook tester"
  s.notes       = <<NOTES
This sublet registers to all possible events/hooks and
just prints their names.
NOTES
  s.version     = "0.0"
  s.tags        = [ "Test" ]
  s.files       = [ "testy.rb" ]
  s.icons       = [ ]
  # s.required_version = "0.9.2127"

  # Gem requirements
  # s.add_dependency("subtle", "~> 0.1.2")
end

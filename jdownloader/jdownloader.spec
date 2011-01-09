# -*- encoding: utf-8 -*-
# Jdownloader specification file
# Created with sur-0.2
Sur::Specification.new do |s|
  s.name        = "Jdownloader"
  s.authors     = [ "unexist" ]
  s.date        = "Sat Sep 25 23:05 CEST 2010"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Show infos about jDownloader"
  s.notes       = <<NOTES
This sublet uses the Remote Control[1] extension of jDownloader[2] to provide
some stats and a simple way to start and stop it.

Per default it tries to connect to localhost on port 10025, the first icon is
also a button and toggles start/stop, followed by current download rate and
numbers of finished and total downloads of the queue.

[1] http://jdownloader.org/knowledge/wiki/addons/list/remotecontrol
[2] http://jdownloader.org
NOTES
  s.config      = [
    { :name => "host", :type => "string",  :description => "Hostname of the remote control" },
    { :name => "port", :type => "integer", :description => "Port of the remove control" },
  ]
  s.version     = "0.2"
  s.tags        = [ "Icon", "HTTP", "Config" ]
  s.files       = [ "jdownloader.rb" ]
  s.icons       = [
    "icons/play.xbm",
    "icons/stop.xbm",
    "icons/net_down_01.xbm",
    "icons/diskette.xbm"
  ]
  s.required_version = "0.9.2148"
end

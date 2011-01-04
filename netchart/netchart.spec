# Netchart specification file
# Created with sur-0.1.129
Sur::Specification.new do |s|
  s.name        = "Netchart"
  s.authors     = [ "unexist" ]
  s.date        = "Mon Mar 01 00:53 CET 2010"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Show rx/tx data of given interface"
  s.notes       = <<NOTES
This sublet just displays the current rx/tx of a given device
(default: wlan0) in a chart. Default device is wlan0.
NOTES
  s.config      = [
    { :name => "device", :type => "string",  :description => "Name of the monitored device (like wlan0)" }
  ]
  s.version     = "0.2"
  s.tags        = [ "Icon", "Chart", "Config" ]
  s.files       = [ "netchart.rb" ]
  s.icons       = [
    "icons/net_down_03.xbm",
    "icons/net_up_03.xbm"
  ]
end

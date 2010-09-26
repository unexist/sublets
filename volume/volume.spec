# Volume specification file
# Created with sur-0.2.143
Sur::Specification.new do |s|
  s.name        = "Volume"
  s.authors     = [ "unexist" ]
  s.date        = "Fri Apr 2 22:40 CEST 2010"
  s.contact     = "unexist@dorfelite.net"
  s.description = "Control the volume with mouse wheel"
  s.version     = "0.0"
  s.tags        = [ "Icon", "Ioctl", "Linux" ]
  s.files       = [ "volume.rb" ]
  s.icons       = [
    "icons/spkr_01.xbm",
    "icons/spkr_02.xbm"
  ]

  # Need specific versions
  s.subtlext_version = "0.9.1856"
  s.sur_version      = "0.2.152"
end

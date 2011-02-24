# Temp sublet file
# Created with sur-0.1
configure :temp do |s| # {{{
  s.interval = 60
  s.temp     = ""
  s.icon     = Subtlext::Icon.new("temp.xbm")

  # Get temp slot
  s.path = Dir["/sys/devices/virtual/thermal/thermal_zone*"].first
  s.path = File.join(s.path, "temp")
end # }}}

on :run do |s| # {{{
  begin
    file = IO.readlines(s.path).join

    s.temp = file.to_f / 1000

    s.data = "%s%.1fC" % [ s.icon, s.temp ]
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end # }}}

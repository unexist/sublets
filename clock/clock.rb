# Clock sublet file
# Created with sur-0.1
configure :clock do |s|
  s.interval = 60
  s.icon     = Subtle::Icon.new("clock.xbm")
end

on :run do |s|
  s.data = s.icon + Time.now().strftime("%y/%m/%d %H:%M:%S")
end

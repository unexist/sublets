# Wifi sublet file
# Created with sur-0.1
configure :wifi do |s|
  self.interval = 240
  s.icon        = Subtle::Icon.new("wifi_01.xbm")

  # Precompile regex
  s.re_essid     = Regexp.new('.*ESSID:"?(.*?)"?\s*\n')
  s.re_quality   = Regexp.new('.*Quality:?=? ?(\d+)\s*/?\s*(\d*)')

  # Select wifi device
  s.device       = "wlan0"
end

on :run do |s|
  begin
    # Fetch data from iwconfig
    iwconfig         = `iwconfig #{s.device}`
    match, essid     = iwconfig.match(s.re_essid).to_a
    match, low, high = iwconfig.match(s.re_quality).to_a

    s.data = "%s%s (%d/%d)" % [ s.icon, essid, low, high ]
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end

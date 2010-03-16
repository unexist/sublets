# Battery sublet file
# Created with sur-0.1
configure :battery do |s|
  s.interval   = 60
  s.full       = 0
  s.path       = ""
  s.icon_ac    = Subtlext::Icon.new("ac.xbm")
  s.icon_full  = Subtlext::Icon.new("bat_full_02.xbm")
  s.icon_low   = Subtlext::Icon.new("bat_low_02.xbm")
  s.icon_empty = Subtlext::Icon.new("bat_empty_02.xbm")

  # Get battery slot and capacity
  begin
    s.path = Dir["/sys/class/power_supply/B*"].first
    s.full = IO.readlines(s.path + "/charge_full").first.to_i
  rescue 
    raise "Could't find battery"
  end
end

on :run do |s|
  begin
    now     = IO.readlines(s.path + "/charge_now").first.to_i
    state   = IO.readlines(s.path + "/status").first.chop
    percent = (now * 100 / s.full).to_i

    # Select icon
    icon = case state
      when "Charging"  then s.icon_ac
      when "Discharging"
        case percent
          when 67..100 then s.icon_full
          when 34..66  then s.icon_low
          when 0..33   then s.icon_empty
        end
      when "Full"      then s.icon_ac
    end

    s.data = "%d%%%s" % [ percent, icon ]
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end

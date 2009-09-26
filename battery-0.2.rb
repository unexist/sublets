#
# Battery
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the battery state
# Version: 0.2
# Date: Tue Sep 15 12:00 CET 2009
# Tags: Sys Icon
#

class Battery < Subtle::Sublet
  attr_accessor :full, :path, :icon_ac, :icon_full, :icon_low, :icon_empty

  def initialize
    self.interval = 60
    @full         = 0
    @path         = ""

    # Icons
    @icon_ac    = Subtle::Icon.new(ENV["XDG_DATA_HOME"] + "/icons/ac.xbm")
    @icon_full  = Subtle::Icon.new(ENV["XDG_DATA_HOME"] + "/icons/bat_full_02.xbm")
    @icon_low   = Subtle::Icon.new(ENV["XDG_DATA_HOME"] + "/icons/bat_low_02.xbm")
    @icon_empty = Subtle::Icon.new(ENV["XDG_DATA_HOME"] + "/icons/bat_empty_02.xbm")

    # Get battery slot and capacity
    begin
      @path = Dir["/sys/class/power_supply/B*"].first
      @full = IO.readlines(@path + "/charge_full").first.to_i
    rescue 
      raise "Could't find battery"
    end
  end

  def run
    begin
      now     = IO.readlines(@path + "/charge_now").first.to_i
      state   = IO.readlines(@path + "/status").first.chop
      percent = (now * 100 / @full).to_i

      # Select icon
      icon = case state
        when "Charging"  then @icon_ac
        when "Discharging"
          case percent
            when 67..100 then @icon_full
            when 34..66  then @icon_low
            when 0..33   then @icon_empty
          end
        when "Full"      then @icon_ac
      end
  
      self.data = "%d%%%s" % [ percent, icon ]
    rescue => err # Sanitize to prevent unloading
      self.data = "subtle"
      p err
    end
  end
end

# Battery sublet file
# Created with sur-0.1

class Battery
  attr_accessor :path_now, :path_state, :name_now, :name_state
  attr_accessor :uevent, :now, :state, :full, :percent

  ## initialize
  # Initialize instance
  # @param  [String]  path  Basepath of battery
  ##

  def initialize(path)
    # Use uevent file
    if File.exist?(File.join(path, "uevent"))
      @path_now = File.join(path, "uevent")
      @uevent   = true

      # Get full capacity
      values = file2hash(path_now)

      [ "POWER_SUPPLY_CHARGE_FULL",
          "POWER_SUPPLY_ENERGY_FULL" ].each do |name|
        if values.has_key?(name)
          @full     = values[name].to_i
          @name_now = name.gsub("FULL", "NOW")
        end
      end

    # Use other files
    else
      if File.exist?(File.join(path, "charge_full"))
        @path_now = File.join(path, "charge_now")
        full      = "charge_full"
      elsif File.exist?(File.join(path, "energy_full"))
        @path_now = File.join(path, "energy_now")
        full      = "energy_full"
      end

      # Finally get full capacity
      @full = IO.readlines(File.join(path, full)).first.to_i

      # Set state file
      @path_state = File.join(path, "state")
    end
  end

  ## text2hash
  # Read content and convert to hash
  # @param  [String]  path  Basepath of battery
  ##

  def text2hash(path)
    lines = IO.readlines(path)

    hash = if @uevent
      Hash[*lines.split(/[\n=]/).flatten]
    else
      { nil => lines }
    end
  end

  ## update
  # Update battery
  ##

  def update
    @now     = text2hash(@path_now)
    @state   = text2hash(@path_state)
    @percent = (now * 100 / s.full).to_i
  end
end

configure :battery do |s| # {{{
  s.interval  = 60
  s.color     = ""
  s.batteries = []

  # Icons
  s.icons = {
    :ac      => Subtlext::Icon.new("ac.xbm"),
    :full    => Subtlext::Icon.new("bat_full_02.xbm"),
    :low     => Subtlext::Icon.new("bat_low_02.xbm"),
    :empty   => Subtlext::Icon.new("bat_empty_02.xbm"),
    :unknown => Subtlext::Icon.new("ac.xbm")
  }

  # Options
  s.color_text = true  == s.config[:color_text]
  s.color_icon = false == s.config[:color_icon] ? false : true
  s.color_def  = Subtlext::Subtle.colors[:sublets_fg]

  # Collect colors
  if s.config[:colors].is_a?(Hash)
    s.colors = {}

    s.config[:colors].each do |k, v|
      s.colors[k] = Subtlext::Color.new(v)
    end

    # Just sort once
    s.color_keys = s.colors.keys.sort.reverse
  end

  # Find batteries
  begin
    ([ s.config[:path] ] || Dir["/sys/class/power_supply/B*"]).each do |path|
      s.batteries = Batter.new(path)
    end
  rescue => err
    p err, err.backtrace
  end
end # }}}

on :run  do |s| # {{{
  s.batteries.each do |b|
    begin

    # Select color
    unless(s.colors.nil?)
      # Find start color from top
      s.color_keys.each do |k|
        break if(k < percent)
        s.color = s.colors[k] if(k >= percent)
      end
    end

    # Select icon for state
    icon = case state
      when "Charging"  then :ac
      when "Discharging"
        case percent
          when 67..100 then :full
          when 34..66  then :low
          when 0..33   then :empty
        end
      when "Full"      then :ac
      else                  :unknown
    end

    s.data = "%s%s%s%d%%" % [
      s.color_icon ? s.color : s.color_def, s.icons[icon],
      s.color_text ? s.color : s.color_def, percent
    ]
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end # }}}

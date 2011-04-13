# Cpu sublet file
# Created with sur-0.1

# Gradient class
class Gradient # {{{

  ## initialize {{{
  # Create color gradient
  # @param [Icon]    start_color  Start color
  # @param [Icon]    end_color    End color
  # @param [Fixnum]  steps        Gradient steps
  ##

  def initialize(start_color, end_color, steps = 10)
    @start_color = check_color(start_color)
    @end_color   = check_color(end_color)
    @steps       = steps
    @gradient    = []

    calculate
  end # }}}

  ## [] {{{
  # Get gradient colors
  # @param [Fixnum]  index  Gradient index
  # @return [Color] Gradient color
  ##

  def [](index)
    if(0 <= index and index < @gradient.size)
      @gradient[index]
    else
      raise "Invalid gradient step"
    end
  end # }}}

  ## steps {{{
  # Get amount of gradient steps
  # @return [Fixnum]  Amount of gradient steps
  ##

  def steps
    @gradient.size
  end # }}}

  private

  def check_color(value) # {{{
    color = nil

    # Check object type
    if(value.is_a?(String))
      color = Subtlext::Color.new(value)
    elsif(value.is_a?(Subtlext::Color))
      color = value
    else
      raise "Invalid color"
    end

    color
  end # }}}

  def calculate # {{{
    # Calculate increment values
    red_incr   = (@start_color.red   - @end_color.red).abs   / (@steps - 1)
    green_incr = (@start_color.green - @end_color.green).abs / (@steps - 1)
    blue_incr  = (@start_color.blue  - @end_color.blue).abs  / (@steps - 1)

    # Calculate intermediate colors
    (1..@steps).each do |i|
      red   = @start_color.red   + red_incr   * i
      green = @start_color.green + green_incr * i
      blue  = @start_color.blue  + blue_incr  * i

      # Check bounds
      red   = 255 if(255 < red)
      green = 255 if(255 < green)
      blue  = 255 if(255 < blue)

      @gradient[i] = Subtlext::Color.new(red, green, blue)
    end

    # Add start and end color
    @gradient[0]          = @start_color
    @gradient[@steps + 1] = @end_color
  end # }}}
end # }}}

configure :cpu do |s|
  s.interval = 30
  s.cpus     = 0
  s.last     = []
  s.delta    = []
  s.sum      = []
  s.icon     = Subtlext::Icon.new("cpu.xbm")

  # Create gradient
  colors     = Subtlext::Subtle.colors
  s.gradient = Gradient.new(colors[:sublets_fg], colors[:title_fg])

  # Init and count CPUs
  begin
    file = IO.readlines("/proc/stat").join

    file.scan(/cpu(\d+)/) do |num| 
      n           = num.first.to_i
      s.cpus     += 1
      s.last[n]   = 0
      s.delta[n]  = 0
      s.sum[n]    = 0
    end
  rescue
    raise "Init error"
  end
end

on :run do |s|
  begin
    data = ""
    time = Time.now.to_i
    file = IO.readlines("/proc/stat").join

    file.scan(/cpu(\d+) (\d+) (\d+) (\d+)/) do |num, user, nice, system| 
      n          = num.to_i
      s.delta[n] = time - s.last[n]
      s.delta[n] = 1 if(0 == s.delta[n])
      s.last[n]  = time

      # Calculate usage
      sum       = user.to_i + nice.to_i + system.to_i
      use       = ((sum - s.sum[n]) / s.delta[n] / 100.0)
      s.sum[n]  = sum
      percent   = (use * 100.0).ceil % 100

      data << "%s%d%% " % [ s.gradient[percent/s.gradient.steps], percent ]
    end

    s.data = s.icon + data.chop
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end  
end

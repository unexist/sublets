# Netchart sublet file
# Created with sur-0.1.129
class Chart < Subtlext::Icon # {{{
  # Data store
  attr_accessor :data

  ## initialize {{{
  # Initialize chart
  # @param [Fixnum, #read]  width   Icon width
  # @param [Fixnum, #read]  height  Icon height
  ##

  def initialize(width, height)
    super
    @data = []
  end # }}}

  ## push {{{
  # Add data to chart
  # @param [Fixnum, #read]  value  Value to add
  ##

  def push(value)
    if(value.is_a?(Fixnum))
      norm = (value * @height) / 100 # Normalize size

      # Add data and shift last
      @data.push(0 == norm ? 1 : norm)
      @data.shift if(15 < @data.size)

      render
    end
  end # }}}

  ## render {{{
  # Render chart

  def render
    i = 0
    clear

    # Draw bars
    ((@width - (@data.size * 2))..@width).step(2) do |x|
      if(i < @data.size)
        ((@height - @data[i])..@height).each do |y|
          draw(x, y)
          draw(x + 1, y)
        end
      end

      i += 1
    end
  end # }}}
end # }}}

configure :net do |s| # {{{
  s.interval = 30
  s.dev      = s.config[:device] || "wlan0"
  s.limit    = 1000
  s.last     = 0

  # Init rx
  s.rx = {
    :gauge => Chart.new(30, 10),
    :icon  => Subtlext::Icon.new("net_down_03.xbm"),
    :data  => 0
  }

  # Init tx
  s.tx = {
    :gauge => Chart.new(30, 10),
    :icon  => Subtlext::Icon.new("net_up_03.xbm"),
    :data  => 0
  }
end # }}}

on :run do |s| # {{{^
  begin
    # Fetch data
    data_rx = IO.readlines("/sys/class/net/#{s.dev}/statistics/rx_bytes").first.to_i
    data_tx = IO.readlines("/sys/class/net/#{s.dev}/statistics/tx_bytes").first.to_i

    # Get time
    time   = Time.now.to_i
    delta  = time - s.last
    s.last = time

    # Get rx/tx per second in kb
    rx = ((data_rx - s.rx[:data]) / delta / 1024.0).ceil
    tx = ((data_tx - s.tx[:data]) / delta / 1024.0).ceil

    # Store values
    s.rx[:data] = data_rx
    s.tx[:data] = data_tx

    # Update gauges
    s.rx[:gauge].push(rx * 100 / s.limit)
    s.tx[:gauge].push(tx * 100 / s.limit)
  rescue => error
    p error.to_s
    p error.backtrace
  end

  self.data = "%s%s %s%s" % [
    s.rx[:icon], s.rx[:gauge].to_s,
    s.tx[:icon], s.tx[:gauge].to_s
  ]
end # }}}

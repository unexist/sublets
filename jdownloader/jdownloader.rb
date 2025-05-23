# Jdownloader sublet file
# Created with sur-0.2

require "net/http"
require "uri"

configure :jdownloader do |s| # {{{
  # Settings
  s.interval = s.config[:interval] || 30
  s.host     = s.config[:host]     || "localhost"
  s.port     = s.config[:port]     || 10025

  # State
  s.state = :stop

  # Icons
  s.icons = {
    :start => Subtlext::Icon.new("play.xbm"),
    :stop  => Subtlext::Icon.new("stop.xbm"),
    :down  => Subtlext::Icon.new("net_down_01.xbm"),
    :disk  => Subtlext::Icon.new("diskette.xbm")
  }

  # Init http
   s.http = Net::HTTP.new(self.host, self.port)
end # }}}

helper do |s| # {{{
  def request(string) # {{{
    req = Net::HTTP::Get.new(string)

    req.initialize_http_header({"User-Agent" => "jdownloader sublet"})

    self.http.request(req).body
  end # }}}

  def status # {{{
    speed      = 0
    all        = 0
    finished   = 0
    self.state = :stop

    begin
      # Fetch data
      status   = request("/get/downloadstatus")
      speed    = request("/get/speed").to_i
      all      = request("/get/downloads/allcount").to_i
      finished = request("/get/downloads/finishedcount").to_i

      # Set state
      self.state = case status
        when "RUNNING"     then :start
        when "NOT_RUNNING" then :stop
        when "STOPPING"    then :stop
      end
    rescue
    end

    # Set state data
    self.data = "%s %s%dkb/s %s%d/%d" % [
      self.icons[(:start == self.state ? :stop : :start)], #< Reverse logic
      self.icons[:down],
      speed,
      self.icons[:disk],
      finished,
      all
    ]
  end # }}}
end # }}}

on :mouse_down do |s, x, y, b| # {{{
  case x
    when 0..14
      # Toggle state
      case s.state
        when :stop  then request("/action/start")
        when :start then request("/action/stop")
      end
  end

  status
end # }}}

on :run do |s| # {{{
  status
end # }}}

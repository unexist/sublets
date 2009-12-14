#
# Mpd
#
# Author: Christoph Kappel
# Contact: unexist@dorfelite.net
# Description: Show the current track
# Version: 0.2
# Date: Fri May 23 00:25 CET 2009
# Tags: Shell DSL Depcrecated
#

configure :mpd do |s|
  s.interval = 30
end

helper do |s|
  def shorten(str, limit = 30)
    return "subtle" if(str.nil?)

    if(str.length > limit)
      str[0..limit] + ".."
    else
      str
    end
  end
end

on :run do |s|
  begin
    matches = `mpc`.match(/(.*)\n\[(.*)\].* ([0-9:]+)\/([0-9:]+)/)

    if(!matches.nil?)
      title, state, ctime, ttime = matches.captures

      s.data = s.shorten(title)
    else
      s.data = "mpd stopped/not running"
    end
  rescue => err # Sanitize to prevent unloading
    s.data = "subtle"
    p err
  end
end

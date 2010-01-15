# Mpd sublet file                                                                                          
# Created with sur-0.1 
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

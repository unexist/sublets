# Spotify sublet file
# Created with sur-0.2
require "dbus"

configure :spotify do |s|
  s.interval = 60

  # Icons
  s.icons = {
    :Play      => Subtlext::Icon.new("play.xbm"),
    :Pause     => Subtlext::Icon.new("pause.xbm"),
    :Stop      => Subtlext::Icon.new("stop.xbm"),
    :Previous  => Subtlext::Icon.new("prev.xbm"),
    :Next      => Subtlext::Icon.new("next.xbm")
  }

  # Create DBus session
  dbus     = DBus::SessionBus.instance
  service  = dbus.service("org.mpris.MediaPlayer2.spotify")
  s.player = service.object("/org/mpris/MediaPlayer2")

  s.player.introspect

  s.state  = :Stop
end

on :run do |s|
  update_status
end

helper do |s| # {{{
  def toggle_state # {{{
    case self.state
      when :Stop  then :Play
      when :Pause then :Pause
      when :Play  then :Pause
    end
  end # }}}

  def send_action(action) # {{{
    self.state = action unless [ :Previous, :Next ].include? action

    self.player.send(action)
  end # }}}

  def update_status # {{{
    icon = :play

    # Assemble data based on state
    case self.state
      when :Play  then icon = :Pause
      when :Pause then icon = :Play
      when :Stop  then icon = :Play
    end

    self.data = "%s%s%s%s" % [
      self.icons[:Previous],
      self.icons[icon],
      self.icons[:Stop],
      self.icons[:Next]
    ]
  end # }}}
end # }}}

on :mouse_down do |s, x, y, b| # {{{
  # Handle clicks based on x coord
  action = case x
    when  0..15 then :Previous
    when 16..31 then toggle_state
    when 32..47 then :Stop
    when 48..63 then :Next
  end

  send_action(action)

  update_status
end # }}}

# Other grabs {{{
{
  :SpotifyPlay => :Play,  :SpotifyPause    => :Pause,
  :SpotifyStop => :Stop,  :SpotifyPrevious => :Previous,
  :SpotifyNext => :Next
}.each do |k, v|
  grab k do |s|
    send_action(v)
  end
end # }}}
